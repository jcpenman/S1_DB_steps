-- DSA_ALLOWANCE.sql
-- Description: Table holding all DSA ALLOWANCE data for SGAS
-- Author R. Hunter.(SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      24.09.09    R Hunter (SAAS)         Initial Version.
-- 1.1      24.09.09    A.Bowman (SAAS)         Added audit triggers
-- 1.2      06.10.09    A.Bowman (SAAS)         Added new columns and amended trigger accordingly
-- 1.3      16.11.09    A.Bowman (SAAS)         Moved the following columns from this table to the DSA_PAYMENT table
--                                              amount_rate, reference, period_start_date, period_end_date, receipt_required, receipt_received,
--                                              receipt_amount, invoice_ref and notes.
--                                              Renamed the increase_max and move_allowance columns to statutory_override_limit and general_override_limit respectively
--                                              Removed the nominee_id column.
--                                              Amended the audit trigger in line with these changes.
-- 1.4      28.01.10    A.Bowman (SAAS)         Amended audit triggers
-- 1.5      05.05.10    A.Bowman (SAAS)         Added foreign key references
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.DSA_ALLOWANCE
 DROP PRIMARY KEY CASCADE
/

DROP TABLE sgas.dsa_allowance CASCADE CONSTRAINTS PURGE
/
--
CREATE TABLE SGAS.DSA_ALLOWANCE
(
  ID                           NUMBER(10)       NOT NULL,
  DSA_APPLICATION_ID           NUMBER(10),
  STUD_SESSION_ID              NUMBER(10),
  STUD_CRSE_YEAR_ID            NUMBER(10),
  DSA_CATEGORY_ID              NUMBER(10),
  MAX_AMOUNT                   NUMBER(15,2),
  AVAILABLE_AMOUNT             NUMBER(15,2),
  PAID_AMOUNT                  NUMBER(15,2),
  TRAVEL_AMOUNT                NUMBER(15,2),
  PAYMENT_DUE_DATE             DATE,
  DATE_PAID                    DATE,
  STATUTORY_OVERRIDE_LIMIT     VARCHAR2(1 BYTE) DEFAULT 'N',
  GENERAL_OVERRIDE_LIMIT       VARCHAR2(1 BYTE) DEFAULT 'N',
  LAST_UPDATED_BY              VARCHAR2(15 BYTE) DEFAULT USER NOT NULL,
  LAST_UPDATED_ON              DATE             DEFAULT SYSDATE               NOT NULL,
  NMPH_HOURS                   NUMBER(2),
  NMPH_HOURLY_RATE             NUMBER(5,2),
  NMPH_WEEKS                   NUMBER(2),
  NMPH_RECOMMENDED_PROVIDER    VARCHAR2(150 BYTE),
  TRAVEL_JOURNEYS              NUMBER(2),
  TRAVEL_COSTS                 NUMBER(5,2),
  TRAVEL_WEEKS                 NUMBER(2),
  TRAVEL_RECOMMENDED_PROVIDER  VARCHAR2(150 BYTE),
  TRAVEL_PROVIDER_ID           NUMBER(10),
  NMPH_TYPE_OF_SUPPORT         VARCHAR2(50 BYTE),
  ITEMISED                     VARCHAR2(1 BYTE),
  START_POSTCODE               VARCHAR2(8 BYTE),
  END_POSTCODE                 VARCHAR2(8 BYTE),
  PAY_HEI                      VARCHAR2(1 BYTE),
  NMPH_MAX_RESTRICTED          VARCHAR2(1 BYTE),
  ACCOM_STANDARD_COST          NUMBER(5,2),
  ACCOM_ENHANCED_COST          NUMBER(5,2),
  ACCOM_WEEKS                  NUMBER(2)
)
TABLESPACE STEPS_DATA
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;


CREATE UNIQUE INDEX SGAS.DSA_ALLOWANCE_PK ON SGAS.DSA_ALLOWANCE
(ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT DSA_ALLOWANCE_PK
  PRIMARY KEY
  (ID)
  USING INDEX SGAS.DSA_ALLOWANCE_PK
  ENABLE VALIDATE);


CREATE INDEX SGAS.S1_DSAA ON SGAS.DSA_ALLOWANCE
(DSA_APPLICATION_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SGAS.S2_DSAA ON SGAS.DSA_ALLOWANCE
(STUD_SESSION_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SGAS.S3_DSAA ON SGAS.DSA_ALLOWANCE
(STUD_CRSE_YEAR_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE OR REPLACE TRIGGER SGAS.DSA_ALL_IUD
   AFTER INSERT OR DELETE OR UPDATE OF ID,
                                       dsa_application_id,
                                       stud_session_id,
                                       stud_crse_year_id,
                                       dsa_category_id,                    
                                       max_amount,
                                       available_amount,
                                       paid_amount,
                                       travel_amount,
                                       payment_due_date,
                                       date_paid,
                                       statutory_override_limit,
                                       general_override_limit,
                                       last_updated_by 
ON SGAS.DSA_ALLOWANCE FOR EACH ROW
DECLARE
   p_aud_date       DATE                                        := SYSDATE;
   p_column_name    DSA_ALLOWANCE_aud.column_name%TYPE    := NULL;
   p_table_pkey1    DSA_ALLOWANCE_aud.table_pkey1%TYPE
                                               := :OLD.ID;
   p_table_pkey2    DSA_ALLOWANCE_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3    DSA_ALLOWANCE_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4    DSA_ALLOWANCE_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5    DSA_ALLOWANCE_aud.table_pkey5%TYPE    := NULL;
   p_old            DSA_ALLOWANCE_aud.OLD%TYPE            := NULL;
   p_new            DSA_ALLOWANCE_aud.NEW%TYPE            := NULL;
   p_action         DSA_ALLOWANCE_aud.action%TYPE         := NULL;
   p_username       DSA_ALLOWANCE_aud.username%TYPE       := :NEW.LAST_UPDATED_BY;
   p_stud_ref_no    DSA_ALLOWANCE_aud.stud_ref_no%TYPE    := NULL;
   p_inst_code      DSA_ALLOWANCE_aud.inst_code%TYPE      := NULL;
   p_session_code   DSA_ALLOWANCE_aud.session_code%TYPE   := NULL;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_table_pkey1 := :OLD.id;
      p_username := :OLD.LAST_UPDATED_BY;
   END IF;

   p_column_name := 'ID';
   p_old := :OLD.id;
   p_new := :NEW.id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'dsa_application_id';
   p_old := :OLD.dsa_application_id;
   p_new := :NEW.dsa_application_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'stud_session_id';
   p_old := :OLD.stud_session_id;
   p_new := :NEW.stud_session_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'stud_crse_year_id';
   p_old := :OLD.stud_crse_year_id;
   p_new := :NEW.stud_crse_year_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'dsa_category_id';
   p_old := :OLD.dsa_category_id;
   p_new := :NEW.dsa_category_id;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'max_amount';
   p_old := :OLD.max_amount;
   p_new := :NEW.max_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'available_amount';
   p_old := :OLD.available_amount;
   p_new := :NEW.available_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'paid_amount';
   p_old := :OLD.paid_amount;
   p_new := :NEW.paid_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'travel_amount';
   p_old := :OLD.travel_amount;
   p_new := :NEW.travel_amount;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'payment_due_date';
   p_old := :OLD.payment_due_date;
   p_new := :NEW.payment_due_date;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'date_paid';
   p_old := :OLD.date_paid;
   p_new := :NEW.date_paid;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'statutory_override_limit';
   p_old := :OLD.statutory_override_limit;
   p_new := :NEW.statutory_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'general_override_limit';
   p_old := :OLD.general_override_limit;
   p_new := :NEW.general_override_limit;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );
   p_column_name := 'last_updated_by';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_DSA_ALL_aud (p_aud_date,
                                       p_column_name,
                                       p_table_pkey1,
                                       p_table_pkey2,
                                       p_table_pkey3,
                                       p_table_pkey4,
                                       p_table_pkey5,
                                       p_old,
                                       p_new,
                                       p_action,
                                       p_username,
                                       p_stud_ref_no,
                                       p_inst_code,
                                       p_session_code
                                      );                                   
  
END DSA_ALL_IUD;
/


DROP SEQUENCE SGAS.DSA_ALLOWANCE_ID_SEQ;

CREATE SEQUENCE SGAS.DSA_ALLOWANCE_ID_SEQ
  START WITH 1757
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
  NOKEEP
  NOSCALE
  GLOBAL;


CREATE OR REPLACE TRIGGER SGAS.TRIG_DSA_ALLOWANCE_ID_SEQ
   BEFORE INSERT
   ON SGAS.DSA_ALLOWANCE    FOR EACH ROW
BEGIN
   SELECT dsa_allowance_id_seq.NEXTVAL
     INTO :NEW.id
     FROM DUAL;
END;
/


CREATE OR REPLACE PUBLIC SYNONYM DSA_ALLOWANCE FOR SGAS.DSA_ALLOWANCE;


ALTER TABLE SGAS.DSA_ALLOWANCE ADD (
  CONSTRAINT DSA_ALLOWANCE_R01 
  FOREIGN KEY (TRAVEL_PROVIDER_ID) 
  REFERENCES SGAS.DSA_TRAVEL_PROVIDER (DSA_TRAVEL_PROVIDER_ID)
  ENABLE VALIDATE
,  CONSTRAINT F1_DSAA 
  FOREIGN KEY (DSA_APPLICATION_ID) 
  REFERENCES SGAS.DSA_APPLICATION (ID)
  ENABLE VALIDATE
,  CONSTRAINT F2_DSAA 
  FOREIGN KEY (STUD_SESSION_ID) 
  REFERENCES SGAS.STUD_SESSION (STUD_SESSION_ID)
  ENABLE VALIDATE
,  CONSTRAINT F3_DSAA 
  FOREIGN KEY (STUD_CRSE_YEAR_ID) 
  REFERENCES SGAS.STUD_CRSE_YEAR (STUD_CRSE_YEAR_ID)
  ENABLE VALIDATE
,  CONSTRAINT F4_DSAA 
  FOREIGN KEY (DSA_CATEGORY_ID) 
  REFERENCES SGAS.DSA_CATEGORY (DSA_CATEGORY_ID)
  ENABLE VALIDATE);


-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM dsa_allowance
/
CREATE PUBLIC SYNONYM dsa_allowance FOR sgas.dsa_allowance
/
DROP SEQUENCE sgas.dsa_allowance_id_seq
/
--
-- DSA_ALLOWANCE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.dsa_allowance_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_dsa_allowance_id_seq
   BEFORE INSERT
   ON sgas.dsa_allowance
   FOR EACH ROW
BEGIN
   SELECT dsa_allowance_id_seq.NEXTVAL
     INTO :NEW.id
     FROM DUAL;
END; 
                                                                      

COMMIT;


