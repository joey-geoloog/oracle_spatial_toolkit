/***********************************************************************
*
*N  {oracle_spatial_toolkit.update_db_metadata_extent}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This procedure allows for the automated updating of spatial metadata
*     extents within the database.
*	    Where the current session user is not the same as the schema owner of
*	    the intended object, it is then necessary to have additional privs to
* 	  update into MDSYS.SDO_GEOM_METADATA_TABLE.
*	    This procedure can also be used for (materialized) views, but the
*     spatial metadata must already exist!
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
