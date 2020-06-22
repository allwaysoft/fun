CREATE INDEX [IX_library_libtype_id_lib_title_parent_id] ON [ektron76].[dbo].[library] ([libtype_id],[lib_title], [parent_id]) 
INCLUDE ([lib_id], [filename], [content_id], [content_language], [user_id], [date_created], [last_edit_date], 
[last_edit_fname], [last_edit_lname], [content_type], [lock_content_link], [parent_lib_id])

drop index IX_library_libtype_id_lib_title_parent_id on library 



select 'AftrIndxStatEvryTime-3'
go
update statistics library
go
exec mbta_DisplayRouteDownloadLinks @routeName= 'Dedham', @transittype = 'all'
go


-- I have made the profiler create below table to insert all the data it captured while I was testing with indexes
select * from library_dbadmin_profiler
where eventclass = 41 
and textdata not like '%update statistics library%'
order by eventsequence