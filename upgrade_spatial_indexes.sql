/***********************************************************************
*
*N  {oracle_spatial_toolkit.upgrade_spatial_indexes}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This script upgrades tables (not views) from spatial indexes with type
*     MDSYS.SPATIAL_INDEX to the new type MDSYS.SPATIAL_INDEX_V2.
*     As (materialized) views require a drop and recreate, which can affect 
*     grants, these will need to be handled manually.
*     More information on the new spatial index type is available from
*     Oracle at: https://docs.oracle.com/en/database/oracle/oracle-database/19/spatl/indexing-querying-spatial-data.html#GUID-6BBF58C4-10D0-4993-8DF2-60C3157412D7
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    See GitHub commits: 
*	 https://github.com/joey-geoloog/oracle_spatial_toolkit/
*E
***********************************************************************/

-- TODO: define procedure
-- TODO: filter out any invalid tables as far as we can see
-- TODO: exclude any Materialized Views from the automatic regeneration.
-- TODO: build loop to take all missing tables

SELECT ALIC.INDEX_OWNER, ALIC.TABLE_NAME, ALIC.COLUMN_NAME, ATBL.OWNER, ATBL.TABLE_NAME, ATBL.COLUMN_NAME
FROM  ALL_IND_COLUMNS ALIC, ALL_TAB_COLS ATBL
 WHERE ALIC.INDEX_OWNER (+) = ATBL.OWNER
 AND   ALIC.TABLE_NAME  (+) = ATBL.TABLE_NAME
 AND   ALIC.COLUMN_NAME (+) = ATBL.COLUMN_NAME
 AND   ALIC.INDEX_OWNER        IS NULL
 AND   ALIC.TABLE_NAME         IS NULL
 AND   ALIC.COLUMN_NAME        IS NULL
 AND   ATBL.DATA_TYPE_OWNER =  'MDSYS'
 AND   ATBL.DATA_TYPE       =  'SDO_GEOMETRY'
 AND   ATBL.OWNER          !=  'MDSYS';

-- TODO: build with type MDSYS.SPATIAL_INDEX_V2
