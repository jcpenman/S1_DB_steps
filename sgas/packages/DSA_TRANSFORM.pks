CREATE OR REPLACE PACKAGE SGAS.DSA_TRANSFORM
AS
   /******************************************************************************
      NAME:       DSA_TRANSFORM
      PURPOSE:    Pre-Synchronise for DSA Online

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        14/11/2023  RANJ             DSA ONLINE TRANSFER

   ******************************************************************************/

TYPE dsaquote_cursor IS REF CURSOR;

   FUNCTION dsa_application_data_copy_steps
      RETURN VARCHAR2;


   FUNCTION copy_dsa_app_data (
      STUD_REC_DSA      IN complete_web_app_dsa@web%ROWTYPE,
      which_db_to_use   IN VARCHAR2)
      RETURN VARCHAR2;


   FUNCTION create_edm_temp_dsa (
      l_stud_rec_DSA    IN OUT complete_web_app_dsa@web%ROWTYPE,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN;


   FUNCTION create_edm_complete_dsa (
      l_stud_rec_DSA    IN OUT complete_web_app_dsa@web%ROWTYPE,
      p_raw_data_id     IN OUT VARCHAR2,
      p_batch_id        IN OUT VARCHAR2,
      p_envelope_id     IN OUT VARCHAR2,
      p_err_mess        IN OUT VARCHAR2,
      which_db_to_use   IN     VARCHAR2)
      RETURN BOOLEAN;
      
      
   PROCEDURE get_dsa_quote_pdf (
      v_stud_ref_no     IN      VARCHAR2,
      v_session_code    IN      VARCHAR2,
      io_cursor         OUT     dsaquote_cursor,
      error_boolean    OUT      VARCHAR2);
   
END DSA_TRANSFORM;
/