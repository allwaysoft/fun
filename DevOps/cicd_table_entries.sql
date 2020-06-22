/*
--What's REBASE?
--What's SQUASH?
--https://stackoverflow.com/questions/18137175/in-git-what-is-the-difference-between-origin-master-vs-origin-master
*/
--Do the below to skip some commits in between which were manually deployed but now we want to use CICD pipeline to deploy. Below will make the CICD pipeline to consider all the commits which were deployed manually to be skipped by Uping the commit number to the latest manual deployment in ChangeLog table.
select * from Acadian.dbo.ChangeLog
where AppName = '/bisam/database-mssql'
order by ExecutedAt desc;update Acadian.dbo.ChangeLog 
set CommitHash = 'f039b3c8', Files = '<Files><File>baseline</File></Files>'
Where AppName = '/bisam/database-mssql'
and CommitHash = '95e5f944';--As long as there are SSIS and SSRS packages/reports below two tables in the two databases have to be updated for the repo baselining


--If need to do this for SSIS, SSRS, the ChangeLog table is in MSDB
--
--NEW SSIS - BOS-DBSSIS01 for SSIS in msdb DB (new ssis .dtsx packages)
--OLD SSIS - BOS-DB02 for SSIS in both Log DB (for PEQ) and msdb DB (for old .dts packages)
--
--BOS-DBRS02 for SSRS in msdb DB
--msdb DB modifications have to be done in all the environments since snap doesn't refresh system databases of lower environments.insert into msdb.dbo.ChangeLog (AppName,CommitHash,ProjectId,JobId,Status,Files,RunServer,ExecutedBy,ExecutedAt)
values ('/performance/bisam/database-mssql' --This needs to be changed
       ,'724e4229' --This needs to be changed
       ,0
       ,0
       ,'Success'
       ,'<Files><File>baseline</File></Files>'
       ,'BOS-DBUATRS02' --This needs to be changed
       ,'ACADIAN\kpabba' 
       ,'2019-05-14' --This needs to be changed
       )--If need to do this for PEQ scripts, the ChangeLog table is in Log
insert into Log.dbo.ChangeLog (AppName,CommitHash,ProjectId,JobId,Status,Files,RunServer,ExecutedBy,ExecutedAt,Branch)
values ('/operations/database-mssql' --This needs to be changed
       ,'6dc7edfa' --This needs to be changed
       ,0
       ,0
       ,'Success'
       ,'<Files><File>baseline</File></Files>'
       ,'BOS-DB02' --This needs to be changed
       ,'ACADIAN\kpabba'
       ,'2019-06-20' --This needs to be changed
       ,NULL
       )--****


--Above are templates, do not modify.
--****insert into Acadian.dbo.ChangeLog(AppName,CommitHash,ProjectId,JobId,Status,Files,RunServer,ExecutedBy,ExecutedAt)
values ('/operations/database-mssql' --This needs to be changed
       ,'990d58dd' --This needs to be changed
       ,0
       ,0
       ,'Success'
       ,'<Files><File>baseline</File></Files>' --This needs to be changed
       ,'BOS-DBCORE01' --This needs to be changed
       ,'ACADIAN\kpabba'
       ,'2019-06-20' --This needs to be changed
       )
insert into msdb.dbo.ChangeLog --This needs to be changed, DB name
(AppName,CommitHash,ProjectId,JobId,Status,Files,RunServer,ExecutedBy,ExecutedAt)
values ('/operations/sell-check/database-mssql' --This needs to be changed
       ,'4d88c1a8' --This needs to be changed
       ,0
       ,0
       ,'Success'
       ,'<Files><File>baseline</File></Files>' 
       ,'BOS-DBSSIS01' --This needs to be changed
       ,'ACADIAN\kpabba' 
       ,'2019-08-22' --This needs to be changed
       )select * from msdb.dbo.ChangeLog where AppName = '/operations/sell-check/database-mssql' order by ExecutedAt descdelete from accounting.dbo.ChangeLog where AppName = '/operations/database-mssql'
select * from [Log].[dbo].[etlPackage] where Name like '%HoldingFileKAS%' / deploy.ps1 -environment [DEV,QA,UAT] -PRINT--For CICD, we are using some local agents and some which use Docker


/*
CREATE new cicd pipeline
    1. Get the yml, ps1 and json files to the repo which needs pipeline
    2. Update the files as needed. Especially the application name in the JSON file
    3. Create a branch in local for the changes done and push the branch to remote
    4. Test the poweshell script on SOME branch by running it in local
    5. Might have to baseline the repo up to latest commit for this we need to insert a record to the ChangeLog
    6. Try creating protected tags and protect master branch, if not, request Slava to create protected tags for the repo
    7. Request Slave to create runner for UAT and Prod.
*//*Re-run of jobs after snap is not dependent on deploy.ps1 but it is all driven by RenRunJobs.ps1 on the sanp server used.
    Re-run job just looks at the jobs which were previously run on an environment by looking at the msdb.JobLog table (exec msdb.cicd.GetJobsToRerun), creates new jobs for existing jobs and run those.
    If the results from the above Jobs table has a master branch, it is always run 1st and all other the branches later (in case of multi branch deployments). The order in which brances run is not gaurenteed.
    All this above logic is from ReRunJobs.ps1--1. ISSUE: In the below the 'navdata' repo had a role creation and the 'external' repo had the Grant on that role to a proc and none of the repos with those changes were in production. 
--   So, after the snap process happens from production, the CICD job which is part of the snap would rerun the Grant 1st and role creation later on some days.--2. Every time pipeline runs in an environment and is successful, it captures that state in cicd.Jobs, in other words, the latest pipeline run in an env is in cicd.Jobs--3. As part of the snap, you get everything from production to dev, in other words, you get everything which is commited to master (and deployed in production) and after 
--   the snap happens, the CICD job run step gets the jobId from cicd.Jobs table (This is last run on an environment before snap) for a repo and just reruns commitHash of merge 
     of that job again, bringing the database to the state it was before snap.--4. The CICD step of the snap process doesn't care about other earlier jobs which were run on the environments but only goes with the last run job stored in cicd.Jobs tables
--   because non prod environments are branch deployments and anyone deploying a branch is nothing but deploying the diffs between the current master and the changes in THAT branch only.--5. Note that CICD step of snap also doesn't care the order in which the repos picked for deployment and it is not possible to identify which repo sequence to be deployed on a database.
--   THIS IS THE CAUSE OF THE ISSUE.--5. This method has an issue though. Say for instance branch1 is deployed to dev and on top of that branch2 is deployed, if branch1 create a new table t_new and dropped a table t_old 
--   and modified an existing procedure p1 to use t_new instead of t_old (Note that none of this is in master). Now branch2 which took the proc p1 from master which still refers to
--   table t_old but made some changes to the proc. Now, branch2 deployment would fail because t_old doesn't exist in databast anymore.-- Flow of things. AB Job which does the SNAP does the 
        -- 1. Prod DB snap to dev environment happens
        -- 2. In Step12, it RE-RUNS the previous latest cicd job that was run in dev before the snap. The log of this step shows which job for which repo was rerun. Have a look at the log*/select * from msdb.cicd.Jobs
where AppName = '/client-services/cash-flows/navdate/database-mssql'select * from msdb.cicd.Jobs
where AppName = '/client-services/cash-flows/external/database-mssql'select * from Acadian.dbo.ChangeLog
where AppName = '/client-services/cash-flows/navdate/database-mssql'select * from Acadian.dbo.ChangeLog
where AppName = '/client-services/cash-flows/external/database-mssql'exec msdb.cicd.GetJobsToRerun
    SELECT 
        j.AppName,
        j.CommitHash,
        j.ProjectId,
        j.JobId,
        j.ExecutedAt,
        j.Branch
    FROM
        msdb.cicd.Jobs j
    WHERE
        j.Disabled=0 and j.ProjectId>0 and j.JobId>0