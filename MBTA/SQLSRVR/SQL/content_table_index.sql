CREATE NONCLUSTERED INDEX ix_content_content_title_folder_id ON [ektron76].[dbo].[content] ( [content_title], [folder_id] ) ;
GO
CREATE NONCLUSTERED INDEX ix_content_folder_id ON [ektron76].[dbo].[content] ( [folder_id] ) INCLUDE ([content_title]);
GO
CREATE NONCLUSTERED INDEX ix_content_xml_config_id ON [ektron76].[dbo].[content] ( [xml_config_id] ) INCLUDE ([content_id], [content_title]);
GO
update statistics content
go

drop index ix_content_content_title_folder_id on content
drop index ix_content_folder_id on content
drop index ix_content_xml_config_id on content






exec mbta_GetSmartFormXML @contentid=30
exec mbta_GetEmergencyMessage
exec GetEktronContent @contentid=30
exec mbta_DisplayNewsEvents @strMonth=01, @stryear=2010
exec mbta_GetHomepagePromo_multiple
exec mbta_DisplayHomePageLinks
exec mbta_GetCRLineNotesByRoute @route='Fairmount Line'
exec mbta_GetParkingDataByStation @stationname='Concord Station'


exec mbta_GetSmartFormXML @contentid=30
exec mbta_GetEmergencyMessage
exec GetEktronContent @contentid=30
exec mbta_DisplayNewsEvents @strMonth=01, @stryear=2010
exec mbta_GetHomepagePromo_multiple
exec mbta_DisplayHomePageLinks
exec mbta_GetCRLineNotesByRoute @route='Fairmount Line'
exec mbta_GetParkingDataByStation @stationname='Concord Station'


--select * from content where xml_config_id=68


--select count(1) from content 

--where content_html like '%</Event_Date>%'


--select db_id()

--HSWEBDEV03\HSWEBDEV03.[ektron76].[dbo].[content_profiler_output]

select * from content_profiler_output 
where eventclass = 41 
order by eventsequence