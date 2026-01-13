/***********************************************************************
*
*N  {oracle_spatial_toolkit.add_rdnaptrans2018_step1_ops}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This procedure is step one of the adding / updating of RDNAPTRANS
*     to the Oracle Spatial database for EPSG transformation 7000.
*	  Step 1 involves defining the 'new' EPSG transformation and
*	  preparing the op params for loading a grid shift (NTv2) file.
*     Please use EPSG definitions from EPSG.ORG *NOT* epsg.io!!!
*	  Info on the process and the tables used is available here:
*     https://docs.oracle.com/en/database/oracle/oracle-database/21/spatl/lot.html
*     https://docs.oracle.com/cd/E18283_01/appdev.112/e11830/sdo_cs_concepts.htm#SPATL727
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    See GitHub commits: 
*	 https://github.com/joey-geoloog/oracle_spatial_toolkit/
*E
***********************************************************************/

INSERT INTO MDSYS.SDO_COORD_OPS (
   COORD_OP_ID,
   COORD_OP_NAME,
   COORD_OP_TYPE,
   SOURCE_SRID,
   TARGET_SRID,
   COORD_TFM_VERSION,
   COORD_OP_VARIANT,
   COORD_OP_METHOD_ID,
   UOM_ID_SOURCE_OFFSETS,
   UOM_ID_TARGET_OFFSETS,
   INFORMATION_SOURCE,
   DATA_SOURCE,
   SHOW_OPERATION,
   IS_LEGACY,
   LEGACY_CODE,
   REVERSE_OP,
   IS_IMPLEMENTED_FORWARD,
   IS_IMPLEMENTED_REVERSE)
 VALUES (
   7000,
   'Amersfoort to ETRS89 (7) (EPSG OP 7000)',
   'TRANSFORMATION',
   4289,
   4258,
   'RDNAP-Nld 2008',
   9,
   9615,
   NULL,
   NULL,
   'Kadaster and Rijkswaterstaat CIV, working together under the name RDNAP',
   'EPSG',
   1,
   'FALSE',
   NULL,
   1,
   1,
   1);
 
INSERT INTO MDSYS.SDO_COORD_OP_PARAM_VALS (
   COORD_OP_ID,
   COORD_OP_METHOD_ID,
   PARAMETER_ID,
   PARAMETER_VALUE,
   PARAM_VALUE_FILE_REF,
   UOM_ID)
 VALUES (
   7000,
   9615,
   8656,
   NULL,
   'rdtrans2008.gsb',
   NULL);
   
/* TODO: Unclear if this is a 1 to 1 replacement for the process described in add_rdnaptrans2018_step2_gsa.sql
-- text for header
*    Upload your GSA (*not* GSB) file to a server folder and change this at '%FILE_LOC%'.
*    If you still have a GSB file, convert it using the code at Esri/ntv2-file-routines.
-- opening action
CREATE OR REPLACE DIRECTORY NTV2_WORK_DIR AS '%FILE_LOC%';
-- loading routine
EXECUTE SDO_CS.LOAD_EPSG_MATRIX(
	7000,
	8656,
	'NTV2_WORK_DIR',
	'RDTRANS2018.GSA');
   */

EXECUTE SDO_CS.ADD_PREFERENCE_FOR_OP(7000,4289,4258,NULL);

EXECUTE SDO_CS.UPDATE_WKTS_FOR_EPSG_OP(7000);
