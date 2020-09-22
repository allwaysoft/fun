https://www.dbarj.com.br/en/2014/11/rename-schema-oracle-11g-loopback-dblink/
--Above link shows how to move a schema to new schema in a given DB environment but the same could be used to move data from
--one DB environment to other.
--Note that since this datapump is through db link, all data will be moved over network, unlinke traditional dpump where the dump is written to the DB server machine
--Note that this might take time depending on the objects and data that needs to be moved.