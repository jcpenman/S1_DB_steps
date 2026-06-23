CREATE OR REPLACE PACKAGE BODY SGAS.PK_AWARD_LETTER_TRANSFER
AS
   /******************************************************************************
      NAME:       PK_AWARD_LETTER_TRANSFER
      PURPOSE:	  Transfer award letters to web

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        11/11/2015  E. Watson       1. Created this package body.
   ******************************************************************************/

   PROCEDURE push_award_letter_data (error_boolean            OUT VARCHAR2,
                                     ERROR_TEXT               OUT VARCHAR2)
   IS
   BEGIN

         INSERT /*+ APPEND */
               INTO  award_letter@web
            SELECT * FROM award_letter;
      EXCEPTION
         WHEN OTHERS
         THEN
			error_boolean := 'true';
            ERROR_TEXT :=
                  'Unhandled exception '
               || TO_CHAR (SQLCODE)
               || ' while updating award_letter table @web';
            ROLLBACK;
      

   END push_award_letter_data;
   
      PROCEDURE push_dsa_award_letter_data (error_boolean            OUT VARCHAR2,
                                     ERROR_TEXT               OUT VARCHAR2)
   IS
   BEGIN

        DELETE FROM dsa_award_pdf@web 
        WHERE DSA_APPLICATION_NO IN 
        (SELECT DAN.DSA_APPLICATION_ID
       FROM DSA_AWARD_NOTICE dan
       WHERE DAN.PUBLISH_STATUS = 3
       AND DAN.SENT_TO_WEB = 'N'
       AND DAN.CURRENT_RECORD_IND = 'Y');
   
       INSERT /*+ APPEND */
       INTO  dsa_award_pdf@web 
       (DSA_APPLICATION_NO, STUD_REF_NO, STUD_CRSE_YR_ID, SESSION_CODE, AWARD_PDF, CREATED_DATE)
       SELECT DAN.DSA_APPLICATION_ID, DAN.STUD_REF_NO, SCY.STUD_CRSE_YEAR_ID , DAN.SESSION_CODE, DAN.AWARD_PDF, SYSDATE
       FROM DSA_AWARD_NOTICE dan, STUD_CRSE_YEAR scy
       WHERE SCY.STUD_REF_NO = DAN.STUD_REF_NO
       AND SCY.SESSION_CODE = DAN.SESSION_CODE
       AND DAN.PUBLISH_STATUS = 3
       AND DAN.SENT_TO_WEB = 'N'
       AND DAN.CURRENT_RECORD_IND = 'Y'
       AND DAN.DSA_APPLICATION_ID NOT IN (SELECT DSA_APPLICATION_NO FROM dsa_award_pdf@web);
       
      UPDATE DSA_AWARD_NOTICE dan
      SET dan.SENT_TO_WEB = 'Y', dan.SENT_TO_WEB_DATE = SYSDATE
      WHERE DAN.PUBLISH_STATUS = 3
      AND DAN.SENT_TO_WEB = 'N';
               
    EXCEPTION
   
         WHEN OTHERS
         THEN
            error_boolean := 'true';
            ERROR_TEXT :=
                  'Unhandled exception '
               || TO_CHAR (SQLCODE)
               || ' while updating award_letter table @web';
            ROLLBACK;
      

   END push_dsa_award_letter_data;
   
END PK_AWARD_LETTER_TRANSFER;
/