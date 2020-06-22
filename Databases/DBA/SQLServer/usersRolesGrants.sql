/*
From Pete: I probably haven't mentioned it before but there's a stored proc in master on BOS-DBCORE01 that will spit out a login's role membership across 
all databases on the server:  exec master.[dbo].[SPdbaGetAllRoleMemberships] @UserName='ACDN\kcleary'Issue: AD server login was dropped on AD side and that raised SQL Server alerts saying the user doesn't exist in AD. AD account was removed accidentally which should not have been, to supress SQL alerts, SQL login was disabled and then below was done
1. AD account was created later on but remember that though the same account is re-created, AD assigns it a new SID and if the SQL Server login doesn't match the new SID it would still have issues authenticating.
2. So, to get the new SID for the SQL Server login, which can be verified by below SQL, The solution was to drop and recreated the login with the same permissions and user mappings as before, this could be done by using SSMS to script out existing login and permissions and mappings and roles.
    SELECT SUSER_SID('ACDN\svc_webanalyticprod')
3. After the new login was created, the expectation was to have the new SID which matched with the AD account but the SQL Server still had to old SID and didn't match the one with the new SID of AD. The reason for that was that a AD user SID is cached in the machine registry and when
   a new login was created in SQL Server it was getting the SID from the local cache of the machine(which is old value) but not from AD directly. 
4. The work around is to either expire the cahce or completely remove chache temporarily on the database server, below is the link and the settings that need to be changed in registry edit
   https://marclsitinfrablog.wordpress.com/2011/06/25/lsa-lookup-cache/
   
   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa 
   Add this entry -> LsaLookupCacheMaxSize = 0
5. Then drop and recreate the login and associated roles and user mappings on SQL Server
6. Make sure the application works fine now
7. Remove the LsaLookupCacheMaxSize entry from registry of database server so it starts cahcing again.https://sqlity.net/en/2344/create-login-with-hashed-password/ -- Recreate a login using hashed password from different environment
https://stackoverflow.com/questions/19108331/how-grant-execute-and-cross-database-reference-works-in-sql-server --Access objects in different databases 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/xp_logininfo 'ACDN\nkrishnadas','all' --Get all the SQL Server principle groups a user is part of
sp_helplogins 'ACDN\sqldev' --all databases - roles assigned to a login
sp_helpuser 'ACDN\sqldev' --specific db level roles assigned to a user--syslogins contains the login account.
SELECT * FROM sys.server_principals; --Superceded view
select * from master.dbo.syslogins; --Old view-- Database specific. sysusers Contains one row for each Microsoft Windows user, Windows group, Microsoft SQL Server user, or SQL Server role in the database.
select * from sys.database_principals;
select * from dbo.sysusers;--Be able to view any definition in a DB environment
--https://www.mssqltips.com/sqlservertip/1593/granting-view-definition-permission-to-a-user-or-role-in-sql-server/grant view any definition to "ACDN\SQL_Developers"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prod to NonPord mappings
SELECT 
    pam.LoginName, --production user
    cam.LoginName --dev user
FROM master.dbo.ServiceAccountMapping pam
JOIN master.dbo.ServiceAccountMapping cam ON cam.ParentMappingId = pam.MappingIdmaster.dbo.sp_AAM_CreateNewAccountForAllDbmaster.dbo.sp_AAM_CreateAccountForSingleDbmaster.dbo.snapDatabases;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------sp_helprotect [ [ @name = ] 'object_statement' ]   
     [ , [ @username = ] 'security_account' ]   
     [ , [ @grantorname = ] 'grantor' ]   
     [ , [ @permissionarea = ] 'type' ]  sp_helprotect @username = 'db_executor'     
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------1. Get all roles and privs assigend to a user across all databasesexec master.[dbo].[SPdbaGetAllRoleMemberships] @UserName='ACDN\svc_actvbsqlusertst' --Roles assigned to a user across all DBsexec master.[dbo].[SPdbaGetAllRoleMemberships] @UserName='ACDN\svc_actvbsqlusertst', @DbName = 'ACDN' --Roles assigned to a user on ACDNexec master.[dbo].[SPdbaGetAllRoleMemberships] @RoleName='ActiveBatchRole' --Users assigned to a role across all DBs
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------2. Privileges assigned to a role but also be aware of the public role which any user has access to.
use ACDN
go
declare @RoleName varchar(50) = 'ActiveBatchRole';
SELECT DISTINCT rp.name, ObjectType = rp.type_desc, PermissionType = pm.class_desc, pm.permission_name, pm.state_desc, 
                ObjectType = CASE WHEN obj.type_desc IS NULL OR obj.type_desc = 'SYSTEM_TABLE' 
                                  THEN pm.class_desc 
                                  ELSE obj.type_desc 
                             END, 
                s.name as SchemaName, [ObjectName] = Isnull(ss.name, Object_name(pm.major_id)) 
FROM sys.database_principals rp 
INNER JOIN sys.database_permissions pm ON pm.grantee_principal_id = rp.principal_id 
LEFT JOIN sys.schemas ss ON pm.major_id = ss.schema_id 
LEFT JOIN sys.objects obj ON pm.[major_id] = obj.[object_id] 
LEFT JOIN sys.schemas s ON s.schema_id = obj.schema_id
WHERE  rp.type_desc = 'DATABASE_ROLE' 
       and pm.class_desc <> 'DATABASE'
       and rp.name = @RoleName
ORDER  BY rp.name, rp.type_desc, pm.class_desc 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------3. Check all roles/users who have grants on a specific object
use ACDN
go
exec sp_helprotect 'aamid.SPgetEntity' 
--OR
SELECT OBJECT_NAME(major_id), USER_NAME(grantee_principal_id), permission_name
FROM sys.database_permissions p
WHERE OBJECT_NAME(major_id) = 'aamid.SPrptHntGetCashBalancesForecasts'
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------4. All grants on an object
use DataMart
go
SELECT
    dp.NAME AS principal_name
        ,dp.type_desc AS principal_type_desc
        ,o.NAME AS object_name
        ,o.type_desc
        ,p.permission_name
        ,p.state_desc AS permission_state_desc
    FROM sys.all_objects                          o
        INNER JOIN sys.database_permissions       p ON o.OBJECT_ID=p.major_id
        LEFT OUTER JOIN sys.database_principals  dp ON p.grantee_principal_id = dp.principal_id
    WHERE o.NAME = 'SPGetPFAAllFactorsSnapshot'
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------Current DB user
select CURRENT_USER;--Current windows user
select SYSTEM_USER;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------Connections and users
--Maximum connections allowed by SQL Server
select * from sys.configurations
where name ='user connections'
--Current open connections count to a SQL Server
select * from sys.dm_os_performance_counters
where counter_name ='User Connections'
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Create a login from and existing with passwordhash
SELECT LOGINPROPERTY('sql_qanavdateservice','PASSWORDHASH');use master
godrop login sql_uatnavdateservicealter login sql_uatnavdateservice with password = 
0x0200334F340BBD0C4253FB1A1DE78EE8A4C8EF3AF7F9B7E38C59D62F23740E4C31BEB557F02DFC7C454951E77AADDE529DEE264800CB2E31939168CAC019E756D0241EBB0F03 hashed;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------/*
From Pete: I probably haven't mentioned it before but there's a stored proc in master on BOS-DBCORE01 that will spit out a login's role membership across 
all databases on the server:  exec master.[dbo].[SPdbaGetAllRoleMemberships] @UserName='ACDN\kcleary'
Security Audit Report --BELOW's SCOPE IS PER DB
1) List all access provisioned to a sql user or windows user/group directly 
2) List all access provisioned to a sql user or windows user/group through a database or application role
3) List all access provisioned to the public roleColumns Returned:
UserName        : SQL or Windows/Active Directory user cccount.  This could also be an            Active Directory group.
UserType        : Value will be either 'SQL User' or 'Windows User'.  This reflects the type of user defined for the  SQL Server user account.
DatabaseUserName: Name of the associated user as defined in the database user account.  The database user may not be the same as the server user.
Role            : The role name.  This will be null if the associated permissions to the object are defined at directly on the user account, otherwise this will be the name of the role that the user is a member of.
PermissionType  : Type of permissions the user/role has on an object. Examples could include CONNECT, EXECUTE, SELECT, DELETE, INSERT, ALTER, CONTROL, TAKE OWNERSHIP, VIEW DEFINITION, etc. This value may not be populated for all roles.  Some built in roles have implicit permission definitions.
PermissionState : Reflects the state of the permission type, examples could include GRANT, DENY, etc. This value may not be populated for all roles.  Some built in roles have implicit permission definitions.
ObjectType      : Type of object the user/role is assigned permissions on.  Examples could include USER_TABLE, SQL_SCALAR_FUNCTION, SQL_INLINE_TABLE_VALUED_FUNCTION, SQL_STORED_PROCEDURE, VIEW, etc. This value may not be populated for all roles.  Some built in roles have implicit permission definitions.          
ObjectName      : Name of the object that the user/role is assigned permissions on. This value may not be populated for all roles.  Some built in roles have implicit permission definitions.
ColumnName      : Name of the column of the object that the user/role is assigned permissions on. This value is only populated if the object is a table, view or a table value function. 
*/use DB
go
declare @p_userName varchar(50) = 'ACDN\svc_actvbsqlusertst'
Declare @userName VARCHAR(100) = '%' + @p_userName + '%';
--List all access provisioned to a sql user or windows user/group directly 
SELECT  
[UserName] = CASE princ.[type] WHEN 'S' THEN princ.[name] WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI END,
[UserType] = CASE princ.[type] WHEN 'S' THEN 'SQL User' WHEN 'U' THEN 'Windows User' END,  
[DatabaseUserName] = princ.[name], [Role] = null, [PermissionType] = perm.[permission_name], [PermissionState] = perm.[state_desc], [ObjectType] = obj.type_desc,--perm.[class_desc],       
[ObjectName] = OBJECT_NAME(perm.major_id), [ColumnName] = col.[name]
FROM sys.database_principals princ  --database user
LEFT JOIN sys.login_token ulogin on princ.[sid] = ulogin.[sid] --Login accounts
LEFT JOIN sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id] --Permissions
LEFT JOIN sys.columns col ON col.[object_id] = perm.major_id AND col.[column_id] = perm.[minor_id] --Table columns
LEFT JOIN sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE princ.[type] in ('S','U')  
AND lower(princ.[name]) LIKE lower(@userName)  -- Added this line --CSLAGLE
UNION--List all access provisioned to a sql user or windows user/group through a database or application role
SELECT [UserName] = CASE memberprinc.[type] WHEN 'S' THEN memberprinc.[name] WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI END,
[UserType] = CASE memberprinc.[type] WHEN 'S' THEN 'SQL User' WHEN 'U' THEN 'Windows User' END, 
[DatabaseUserName] = memberprinc.[name], [Role] = roleprinc.[name], [PermissionType] = perm.[permission_name], [PermissionState] = perm.[state_desc], [ObjectType] = obj.type_desc,--perm.[class_desc],   
[ObjectName] = OBJECT_NAME(perm.major_id), [ColumnName] = col.[name]
FROM sys.database_role_members members --Role/member associations
JOIN sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id] --Roles
JOIN sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id] --Role members (database users)
LEFT JOIN sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid] --Login accounts
LEFT JOIN sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id] --Permissions
LEFT JOIN sys.columns col on col.[object_id] = perm.major_id AND col.[column_id] = perm.[minor_id] --Table columns
LEFT JOIN sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE lower(memberprinc.[name]) LIKE lower(@userName)  -- Added this line --CSLAGLE
UNION--List all access provisioned to the public role, which everyone gets by default
SELECT  [UserName] = '{All Users}', [UserType] = '{All Users}', [DatabaseUserName] = '{All Users}', [Role] = roleprinc.[name], [PermissionType] = perm.[permission_name], [PermissionState] = perm.[state_desc], [ObjectType] = obj.type_desc,--perm.[class_desc],  
[ObjectName] = OBJECT_NAME(perm.major_id), [ColumnName] = col.[name]
FROM sys.database_principals roleprinc --Roles
LEFT JOIN sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id] --Role permissions
LEFT JOIN sys.columns col on col.[object_id] = perm.major_id AND col.[column_id] = perm.[minor_id] --Table columns
JOIN sys.objects obj ON obj.[object_id] = perm.[major_id] --All objects
WHERE roleprinc.[type] = 'R' --Only roles
AND roleprinc.[name] = 'public' --Only public role
AND obj.is_ms_shipped = 0 --Only objects of ours, not the MS objects
ORDER BY princ.[name], OBJECT_NAME(perm.major_id), col.[name], perm.[permission_name], perm.[state_desc], obj.type_desc--perm.[class_desc]  
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------