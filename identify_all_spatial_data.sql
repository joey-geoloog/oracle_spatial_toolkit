/***********************************************************************
*
*N  {oracle_spatial_toolkit.identify_all_spatial_data}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This code identifies any tables within the database which contain
*     either vector geometry and rasters for Oracle data types
*     (SDO_GEOMETRY, RASTERBLOB) or ESRI (ST_GEOMETRY, ST_RASTER, BLOB).
*     Connected user must have access to SYS.ALL_TABLES, SYS.ALL_TAB_COLS.
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    See GitHub commits: 
*	   https://github.com/joey-geoloog/oracle-spatial-toolkit/
*E
***********************************************************************/

select col.owner as schema_name,
       col.table_name,
       column_id,
       column_name,
       data_type
from sys.all_tab_cols col
join sys.all_tables tab on col.owner = tab.owner
                        and col.table_name = tab.table_name
where col.data_type IN ('SDO_GEOMETRY','ST_GEOMETRY','ST_RASTER','RASTERBLOB','BLOB')
      and col.owner not in 
      ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS', 'LBACSYS', 
      'MDSYS', 'MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS', 'ORDSYS',
      'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM', 'TSMSYS','WK_TEST',
      'WKPROXY','WMSYS','XDB','APEX_040000', 'APEX_PUBLIC_USER','DIP', 
      'FLOWS_30000','FLOWS_FILES','MDDATA', 'ORACLE_OCM', 'XS$NULL',
      'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR', 'PUBLIC',
      'OUTLN', 'WKSYS', 'APEX_040200')
order by col.owner,
         col.table_name,
         column_id;
