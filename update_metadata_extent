/***********************************************************************
*
*N  {oracle_spatial_toolkit.update_metadata_extent}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This procedure allows for the automated updating of spatial metadata
*     extents within the database.
*	  Where the current session user is not the same as the schema owner of
*	  the intended object, it is then necessary to have additional privs to
* 	  update into MDSYS.SDO_GEOM_METADATA_TABLE.
*	  This procedure can also be used for (materialized) views, but the
*     spatial metadata must already exist!
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    See GitHub commits: 
*	 https://github.com/joey-geoloog/oracle_spatial_toolkit/
*E
***********************************************************************/

create or replace PROCEDURE UPDATE_DB_METADATA_EXTENT
    (tbl NVARCHAR2,
	geomcol NVARCHAR2 DEFAULT 'GEOMETRY',
	usr NVARCHAR2 DEFAULT USER) AS

    v_srid    NUMBER;
    v_min_x   NUMBER;
    v_min_y   NUMBER;
    v_max_x   NUMBER;
    v_max_y   NUMBER;
	no_geometries	EXCEPTION;
	PRAGMA EXCEPTION_INIT(no_geometries, -13034);

BEGIN

WITH qualified as (
      SELECT usr || '.' || tbl AS tbl FROM DUAL),
    bounding as (
    SELECT SDO_TUNE.EXTENT_OF(qual.tbl, geomcol, 'FALSE') AS RESULT
  FROM qualified qual),
  extents as (
    SELECT mbr.result.sdo_srid AS SRID,
        sdo_geom.sdo_min_mbr_ordinate(mbr.result,1) AS min_x,
        sdo_geom.sdo_min_mbr_ordinate(mbr.result,2) AS min_y,
        sdo_geom.sdo_max_mbr_ordinate(mbr.result,1) AS max_x,
        sdo_geom.sdo_max_mbr_ordinate(mbr.result,2) AS max_y
    FROM bounding mbr) 
    
SELECT ext.min_x, ext.min_y, ext.max_x, ext.max_y, ext.srid INTO v_min_x, v_min_y, v_max_x, v_max_y, v_srid FROM extents ext;

IF v_min_x = NULL OR v_min_y = NULL OR v_max_x = NULL OR v_max_y = NULL THEN
    RETURN;
ELSIF usr = SYS_CONTEXT ('USERENV', 'SESSION_USER') THEN
    UPDATE USER_SDO_GEOM_METADATA metadata 
		SET DIMINFO = 
			SDO_DIM_ARRAY (
				SDO_DIM_ELEMENT('X', v_min_x, v_max_x, 0.5), 
				SDO_DIM_ELEMENT('Y', v_min_y, v_max_y, 0.5) 
				) 
				, SRID = v_srid
		WHERE metadata.TABLE_NAME = tbl
		AND metadata.COLUMN_NAME = geomcol;
        COMMIT;
ELSE
	UPDATE MDSYS.SDO_GEOM_METADATA_TABLE
		SET SDO_DIMINFO = 
			SDO_DIM_ARRAY (
				SDO_DIM_ELEMENT('X', v_min_x, v_max_x, 0.5), 
				SDO_DIM_ELEMENT('Y', v_min_y, v_max_y, 0.5)
				), 
			SDO_SRID = v_srid
		WHERE SDO_TABLE_NAME = tbl
		AND SDO_COLUMN_NAME = geomcol
		AND SDO_OWNER = usr;
        COMMIT;
END IF;
EXCEPTION
	WHEN no_geometries THEN
		RETURN;
	WHEN OTHERS THEN
		RAISE;
END;
