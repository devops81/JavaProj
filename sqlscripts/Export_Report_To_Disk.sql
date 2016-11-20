
CREATE OR REPLACE PROCEDURE Export_Report_To_Disk
 ( REPORT_NAME VARCHAR2)
 AS
    v_lob_loc      BLOB;
    v_buffer       RAW(32767);
    v_buffer_size  BINARY_INTEGER;
    v_amount       BINARY_INTEGER;
    v_offset       NUMBER(38) := 1;
    v_chunksize    INTEGER;
    v_out_file     UTL_FILE.FILE_TYPE;

BEGIN
    
 SELECT r.REPORT_DESIGN INTO v_lob_loc FROM reports r WHERE  r.name = REPORT_NAME;

    v_chunksize := DBMS_LOB.GETCHUNKSIZE(v_lob_loc);

    IF (v_chunksize < 32767) THEN
        v_buffer_size := v_chunksize;
    ELSE
        v_buffer_size := 32767;
    END IF;

    v_amount := v_buffer_size;

    DBMS_LOB.OPEN(v_lob_loc, DBMS_LOB.LOB_READONLY);

    v_out_file := UTL_FILE.FOPEN(
        location      => 'ORACLE_REPORT_DIR', 
        filename      => REPORT_NAME||'.jrxml', 
        open_mode     => 'w',
        max_linesize  => 32767);

    WHILE v_amount >= v_buffer_size
    LOOP

      DBMS_LOB.READ(
          lob_loc    => v_lob_loc,
          amount     => v_amount,
          offset     => v_offset,
          buffer     => v_buffer);

      v_offset := v_offset + v_amount;

      UTL_FILE.PUT_RAW (
          file      => v_out_file,
          buffer    => v_buffer,
          autoflush => true);

      UTL_FILE.FFLUSH(file => v_out_file);

    END LOOP;

    UTL_FILE.FFLUSH(file => v_out_file);

    UTL_FILE.FCLOSE(v_out_file);

    DBMS_LOB.CLOSE(v_lob_loc);

END;

