--List table blocks, empty blocks, extent count, and chain block count 

SELECT blocks as BLOCKS_USED, empty_blocks
FROM dba_tables
WHERE table_name='MISCFUNCITEMMOVEMENT';

SELECT chain_cnt AS CHAINED_BLOCKS
FROM dba_tables
WHERE table_name=TNAME;

SELECT COUNT(*) AS EXTENT_COUNT
FROM dba_extents
WHERE segment_name=TNAME;
 
Table Scan:  MBTA.MISCFUNCITEMMOVEMENT: 1240655 out of 1240655 Blocks done


18645860