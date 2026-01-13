/***********************************************************************
*
*N  {oracle_spatial_toolkit.add_rdnaptrans2018_step2_load_ntv2}
*
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*P  Purpose:
*     This procedure updates the RDNAPTRANS Grid Shift Files in the
*     Oracle database following the logic defined by Oracle at:
*     https://docs.oracle.com/cd/E18283_01/appdev.112/e11830/sdo_cs_concepts.htm#CIHBHFCJ
*     Remember to define your working directory on line 40 '%FILE_LOC%' 
*E
*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
*
*H  History:
*
*    See GitHub commits: 
*	 https://github.com/joey-geoloog/oracle_spatial_toolkit/
*E
***********************************************************************/

DECLARE
  ORCL_HOME_DIR VARCHAR2(128);
  ORCL_WORK_DIR VARCHAR2(128);
  Src_loc       BFILE;
  Dest_loc      CLOB;
  CURSOR PARAM_FILES IS
    SELECT
      COORD_OP_ID,
      PARAMETER_ID,
      PARAM_VALUE_FILE_REF
    FROM
      MDSYS.SDO_COORD_OP_PARAM_VALS
    WHERE
      PARAMETER_ID IN (8656, 8657, 8658, 8666);
  PARAM_FILE PARAM_FILES%ROWTYPE;
  ACTUAL_FILE_NAME VARCHAR2(128);
  platform NUMBER;
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE DIRECTORY work_dir AS '%FILE_LOC%'';
 
  FOR PARAM_FILE IN PARAM_FILES LOOP
    CASE UPPER(PARAM_FILE.PARAM_VALUE_FILE_REF)
      /* RDNAPTRANS2008 - used by epsg:7000 */
      WHEN 'rdtrans2008.gsb'   THEN ACTUAL_FILE_NAME := 'rdtrans2018.gsa';
      /* RDNAPTRANS2018 - used by epsg:9282 and others */
      WHEN 'rdtrans2018.gsb'   THEN ACTUAL_FILE_NAME := 'rdtrans2018.gsa';
      ELSE                     ACTUAL_FILE_NAME := NULL;
    END CASE;
 
    IF(NOT (ACTUAL_FILE_NAME IS NULL)) THEN
      BEGIN
        dbms_output.put_line('Loading file ' || actual_file_name || '...');
        Src_loc := BFILENAME('WORK_DIR', ACTUAL_FILE_NAME);
        DBMS_LOB.OPEN(Src_loc, DBMS_LOB.LOB_READONLY);
      END;
 
      UPDATE
        MDSYS.SDO_COORD_OP_PARAM_VALS
      SET
        PARAM_VALUE_FILE = EMPTY_CLOB()
      WHERE
        COORD_OP_ID = PARAM_FILE.COORD_OP_ID AND
        PARAMETER_ID = PARAM_FILE.PARAMETER_ID
      RETURNING
        PARAM_VALUE_FILE INTO Dest_loc;
 
      DBMS_LOB.OPEN(Dest_loc, DBMS_LOB.LOB_READWRITE);
      DBMS_LOB.LOADFROMFILE(Dest_loc, Src_loc, DBMS_LOB.LOBMAXSIZE);
      DBMS_LOB.CLOSE(Dest_loc);
      DBMS_LOB.CLOSE(Src_loc);
      DBMS_LOB.FILECLOSE(Src_loc);
    END IF;
  END LOOP;
END;
/
