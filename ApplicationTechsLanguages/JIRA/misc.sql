assignee = currentUser() 
AND project in ("Team 12 - POPS", Operations, "Performance and Attribution", Seismic, "BISAM Upgrade/Performance Retirement ", "Team Maesters ", "Cash Flows", "North American Client Service") 
    AND status not in (Done, Closed) 
OR 
assignee is EMPTY 
AND project in ("Team 12 - POPS", Operations, "Performance and Attribution", Seismic, "Team Maesters ", "Cash Flows", "North American Client Service") AND status in ("Ready to Release", "Ready to Implement") 
    AND "Release Team" in ("Database Ops", "Database Ops & Release Management", "Delivery Team ") 
ORDER BY duedate ASC, status DESC, Sprint ASC, Rank ASC