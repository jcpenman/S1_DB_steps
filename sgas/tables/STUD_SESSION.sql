-- DDL generated from TOAD and modified by hand
-- for purposes of building the STEPS development
-- schema.
--
-- Modification History
-- Date        Author           Ref    Desc
-- 15.02.08    Steve Durkin     001    New columns.
-- 10.03.09    A.Bowman (SAAS)  002    Added new column stud income
-- 22.06.09    A.Bowman (SAAS)  003    Added audit triggers
-- 27.08.09    A.Bowman (SAAS)  004    Added new auditable column date_applic_received to trigger SGAS.sts_iud
--                                     to meet History requirements
-- 30.09.09    A.Bowman (SAAS)  005    Added new columns as part of CR's 
-- 15.10.09    A.Bowman (SAAS)  006    Added materialized view log script
-- 18.10.09    R.Hunter (SGAS)  007    Grant Access for ILA500 Duplicates View
-- 10.12.09    A.Bowman (SAAS)  008    Added new column fee_loan_charged
-- 28.01.10    A.Bowman (SAAS)  009    Amended audit triggers
-- 15.03.10    A.Bowman (SAAS)  010    Added new column bursary_deduction
-- 29.04.10    A.Bowman (SAAS)  011    Added foreign key references
-- 03.06.10    A.Bowman (SAAS)  012    Added new column SESSION_SUSPEND
-- 26.08.10    A.Bowman (SAAS)  013    Added default of 0 to columns net_income, trust_income, pension_income, working_tax_credit
-- 11.03.11    A.Bowman (SAAS)  014    Added new functionality to trigger STS_IUD to update changed since last report flag on attendance_data table
-- 16.11.12    A.Bowman (SAAS)  015    Added new column eu_flag  
--
-- Configuration Management:
-- $HeadURL: svn://192.168.186.3/projects/sgas/tradev/svnRepositories/steps/trunk/Database/steps/sgas/tables/STUD_SESSION.sql $
-- $Author: $
-- $Date: 2012-11-16 10:43:25 +0000 (Fri, 16 Nov 2012) $
-- $Revision: 8335 $


ALTER TABLE SGAS.STUD_SESSION
 DROP PRIMARY KEY CASCADE
/
DROP TABLE SGAS.STUD_SESSION CASCADE CONSTRAINTS PURGE
/

--
-- STUD_SESSION  (Table) 
--
CREATE TABLE SGAS.STUD_SESSION
(
  STUD_SESSION_ID               NUMBER(9) CONSTRAINT NN_STS_STUD_SESSION_ID NOT NULL,
  STUD_REF_NO                   NUMBER(10) CONSTRAINT NN_STS_STUD_REF_NO NOT NULL,
  SESSION_CODE                  NUMBER(4) CONSTRAINT NN_STS_SESSION_CODE NOT NULL,
  LIFE_INS_DOC                  VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_LIFE_INS_DOC NOT NULL,
  MARRIAGE_CERT                 VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_MARRIAGE_CERT NOT NULL,
  PENSION_DOC                   VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_PENSION_DOC NOT NULL,
  MORTGAGE_INT                  VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_MORTGAGE_INT NOT NULL,
  JA_CASE                       VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_JA_CASE NOT NULL,
  FORENAMES                     VARCHAR2(25 BYTE) CONSTRAINT NN_STS_FORENAMES NOT NULL,
  SURNAME                       VARCHAR2(25 BYTE) CONSTRAINT NN_STS_SURNAME NOT NULL,
  DOB                           DATE CONSTRAINT NN_STS_DOB NOT NULL,
  SEX                           VARCHAR2(1 BYTE) CONSTRAINT NN_STS_SEX NOT NULL,
  RESIDENCE_QUERY               VARCHAR2(1 BYTE) DEFAULT 'N' CONSTRAINT NN_STS_RESIDENCE_QUERY NOT NULL,
  EMP_LOGIN_NAME                VARCHAR2(15 BYTE),
  FIRST_NAME                    VARCHAR2(15 BYTE),
  LAST_NAME                     VARCHAR2(15 BYTE),
  JA_CASE_ID                    NUMBER(6),
  JA_STUD_TYPE                  VARCHAR2(1 BYTE),
  BEN1_ID                       NUMBER(9),
  BEN2_ID                       NUMBER(9),
  BEN1_REL_ID                   NUMBER(4),
  BEN2_REL_ID                   NUMBER(4),
  NET_INCOME                    NUMBER(9,2)     DEFAULT 0,
  TRUST_INCOME                  NUMBER(9,2)     DEFAULT 0,
  PENSION_INCOME                NUMBER(9,2)     DEFAULT 0,
  EMPLOYMENT_DESCRIPT           VARCHAR2(100 BYTE),
  BEN1_START_DATE               DATE,
  BEN1_END_DATE                 DATE,
  BEN2_START_DATE               DATE,
  BEN2_END_DATE                 DATE,
  UNUSED_JA_CONT                NUMBER(9,2)     DEFAULT 0,
  DEDUCTS                       NUMBER(9,2),
  LOAN_DECLARATION_DATE         DATE,
  DATE_APPLIC_RECEIVED          DATE,
  LOAN_REQUEST                  NUMBER(7,2),
  MAX_LOAN_REQUESTED            VARCHAR2(1 BYTE),
  REQ_SENT_DATE                 DATE,
  DOC_REQ_ISSUE                 NUMBER(1),
  PT_LOAN_CHECK                 VARCHAR2(1 BYTE),
  PT_LOAN_CLAIMED               VARCHAR2(1 BYTE),
  SMG_ENTITLEMENT               NUMBER(9,2),
  YSB_ENTITLEMENT               NUMBER(9,2),
  YSO_ENTITLEMENT               NUMBER(9,2),
  MAX_LPCG_PAID                 VARCHAR2(1 BYTE),
  LPCG_PAID_AMOUNT              NUMBER(9,2),
  GE_LIABILITY                  VARCHAR2(1 BYTE),
  SHORT_APP_SENT_DATE           DATE,
  SHORT_APP_REC_DATE            DATE,
  REGISTERED_FOR_DSA            VARCHAR2(1 BYTE),
  DOCUMENT_RECEIPT_DATE         DATE,
  FEE_LOAN_REQUEST_AMOUNT       NUMBER(7,2),
  MAX_FEE_LOAN_REQUESTED        VARCHAR2(1 BYTE),
  FEE_LOAN_DECLARATION_DATE     DATE,
  FEE_LOAN_CHARGED              NUMBER(7,2),
  SOSB_ENTITLEMENT              NUMBER(9,2),
  STUD_HEI_BURSARY_CONSENT      VARCHAR2(1 BYTE),
  SLC1_FL_SENT                  VARCHAR2(1 BYTE),
  SLC1_FL_SENT_DATE             DATE,
  REASON_NO_NINO                NUMBER(4),
  CHILD_CARE_NO                 VARCHAR2(10 BYTE),
  CHILD_CARE_NAME               VARCHAR2(60 BYTE),
  TOTAL_HOUSE_INCOME            NUMBER(9,2),
  STUD_INCOME                   VARCHAR2(1 BYTE),
  WORKING_TAX_CREDIT            NUMBER(9,2)     DEFAULT 0,
  EMPLOYMENT_SUPPORT_ALLOWANCE  VARCHAR2(1 BYTE),
  INCAPACITY_BENEFIT            VARCHAR2(1 BYTE),
  INCOME_SUPPORT                VARCHAR2(1 BYTE),
  INVALIDITY_BENEFIT            VARCHAR2(1 BYTE),
  JOBSEEKERS_ALLOWANCE          VARCHAR2(1 BYTE),
  MAINTENANCE_PAYMENT           VARCHAR2(1 BYTE),
  SDS_DATA_SHARE                VARCHAR2(1 BYTE),
  BURSARY_DEDUCTION             NUMBER(9,2)     DEFAULT 0,
  SESSION_SUSPEND               VARCHAR2(1 BYTE) DEFAULT 'N',
  LAST_UPDATED_BY               VARCHAR2(15 BYTE) DEFAULT User CONSTRAINT NN_STS_LAST_UPDATED_BY NOT NULL,
  LAST_UPDATED_ON               DATE            DEFAULT Sysdate CONSTRAINT NN_STS_LAST_UPDATED_ON NOT NULL,
  EU_FLAG                       VARCHAR2(1 BYTE),
  STUD_HEI_CONSENT              VARCHAR2(1 BYTE),
  CARE_LEAVER                   VARCHAR2(1 BYTE),
  BEN1_AB36                     VARCHAR2(1 BYTE),
  BEN2_AB36                     VARCHAR2(1 BYTE),
  INTERRUPTION_OF_STUDY         VARCHAR2(1 BYTE) DEFAULT 'N' NOT NULL,
  EU_RESIDENCE_TYPE             NUMBER(10),
  DEBT_ONLY                     VARCHAR2(1 BYTE) DEFAULT 'N',
  TOP_OPTION                    VARCHAR2(1 BYTE),
  TOP_CHANGED                   DATE,
  ACCOMMODATION_FORMAL          VARCHAR2(1 BYTE),
  ACCOMMODATION_INFORMAL        VARCHAR2(1 BYTE),
  HOLD_DSA_AWARD_NOTICE         VARCHAR2(1 BYTE)
)
TABLESPACE STEPS_DATA
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          3M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE;

COMMENT ON TABLE SGAS.STUD_SESSION IS 'Holds details related to a student for a particular session';

COMMENT ON COLUMN SGAS.STUD_SESSION.STUD_HEI_BURSARY_CONSENT IS 'Indicates that the student has given permission to share HEI Bursary details';

COMMENT ON COLUMN SGAS.STUD_SESSION.CHILD_CARE_NO IS 'Registration number of childcare provider';

COMMENT ON COLUMN SGAS.STUD_SESSION.CHILD_CARE_NAME IS 'Name of childcare provider';

COMMENT ON COLUMN SGAS.STUD_SESSION.TOTAL_HOUSE_INCOME IS 'Total household income (combined benefactor income for student)';


CREATE UNIQUE INDEX SGAS.P_STS ON SGAS.STUD_SESSION
(STUD_SESSION_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
CREATE UNIQUE INDEX SGAS.U1_STS ON SGAS.STUD_SESSION
(STUD_REF_NO, SESSION_CODE)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          384K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT CHECK_REL1
  CHECK ((ben1_id is not null and ben1_rel_id is not null) or                                 (ben1_id is null and ben1_rel_id is null))
  ENABLE VALIDATE
,  CONSTRAINT CHECK_REL2
  CHECK ((ben2_id is not null and ben2_rel_id is not null) or                                 (ben2_id is null and ben2_rel_id is null))
  ENABLE VALIDATE
,  CONSTRAINT SS_PT_LOAN_CHECK
  CHECK (PT_LOAN_CHECK IN ('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT SS_PT_LOAN_CLAIMED
  CHECK (PT_LOAN_CLAIMED IN ('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_EU_FLAG
  CHECK ( EU_FLAG IN('Y', 'N', NULL))
  ENABLE VALIDATE
,  CONSTRAINT STS_JA_CASE
  CHECK ( JA_CASE IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_JA_STUD_TYPE
  CHECK ( JA_STUD_TYPE IN('P','C','S'))
  ENABLE VALIDATE
,  CONSTRAINT STS_LIFE_INS_DOC
  CHECK ( LIFE_INS_DOC IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_MARRIAGE_CERT
  CHECK ( MARRIAGE_CERT IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_MAX_FEE_LOAN_REQUESTED
  CHECK (max_fee_loan_requested IN ('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_MAX_LPCG_PAID
  CHECK (max_lpcg_paid in('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_MORTGAGE_INT
  CHECK ( MORTGAGE_INT IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_PENSION_DOC
  CHECK ( PENSION_DOC IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_RESIDENCE_QUERY
  CHECK ( RESIDENCE_QUERY IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STS_SLC1_FL_SENT
  CHECK (slc1_fl_sent in ('Y', 'N', 'E'))
  ENABLE VALIDATE
,  CONSTRAINT STS_SUSPEND
  CHECK (session_suspend in ('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STUD1_AB36
  CHECK ( BEN1_AB36 IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT STUD2_AB36
  CHECK ( BEN2_AB36 IN('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT ST_GE
  CHECK (ge_liability in ('Y','N'))
  ENABLE VALIDATE
,  CONSTRAINT P_STS
  PRIMARY KEY
  (STUD_SESSION_ID)
  USING INDEX SGAS.P_STS
  ENABLE VALIDATE);


CREATE INDEX SGAS.S1_STS ON SGAS.STUD_SESSION
(JA_CASE_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SGAS.S2_STS ON SGAS.STUD_SESSION
(BEN1_ID)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SGAS.S3_STS ON SGAS.STUD_SESSION
(EMP_LOGIN_NAME)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SGAS.S4_STS ON SGAS.STUD_SESSION
(BEN2_ID)
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

CREATE INDEX SGAS.S5_STS ON SGAS.STUD_SESSION
(SLC1_FL_SENT)
LOGGING
TABLESPACE STEPS_INDEX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          320K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE OR REPLACE TRIGGER SGAS.STS_AIU
   AFTER UPDATE OF session_suspend
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_action            stud_session_aud.action%TYPE        := NULL;
   p_stud_session_id   stud_session.stud_session_id%TYPE
                                                      := :OLD.stud_session_id;
   v_chngd             VARCHAR2 (1)                        := 'N';
BEGIN
   IF UPDATING
   THEN
      p_action := 'U';
   END IF;

   IF p_action = 'U'
   THEN
      IF :OLD.session_suspend <> :NEW.session_suspend
      THEN
         v_chngd := 'Y';
      END IF;
   END IF;

   IF v_chngd = 'Y'
   THEN
      pk_steps_changes.cslr_stud_sess (p_stud_session_id);
   END IF;
END sts_aiu;
/


CREATE OR REPLACE TRIGGER SGAS.STS_GDPR
AFTER DELETE OR INSERT OR UPDATE
OF BEN1_ID
  ,BEN2_ID
ON SGAS.STUD_SESSION
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
         
           IF NVL(:new.ben1_id,-1) != NVL(:old.ben1_id,-1) --has been updated
           THEN
            IF NVL(:new.ben1_id,-1) = -1 --has been deleted
            THEN
                --Delete the record if a GDPR notification has NOT been sent
                DELETE FROM SGAS.BEN_GDPR WHERE BEN_ID = :old.ben1_id AND STUD_SESSION_ID = :old.stud_session_id AND GDPR_SENT = 'N'; --could be multiple lines with same ben_id and srn -- need stud_session_id
            ELSE
                --If complete record is new SRN and STUD_SESSION cannot be :old.
                INSERT INTO SGAS.BEN_GDPR (BEN_ID, STUD_SESSION_ID, STUD_REF_NO, GDPR_SENT, FLAGGED_FOR_LETTER, LETTER_SESSION) 
                VALUES (:new.ben1_id, NVL(:old.stud_session_id,:new.stud_session_id), NVL(:old.stud_ref_no,:new.stud_ref_no), 'N', SYSDATE, NVL(:new.SESSION_CODE,:old.SESSION_CODE));
            END IF;
           END IF;
           
           
           IF NVL(:new.ben2_id,-1) != NVL(:old.ben2_id,-1)
           THEN
            IF NVL(:new.ben2_id,-1) = -1
            THEN
                DELETE FROM SGAS.BEN_GDPR WHERE BEN_ID = :old.ben2_id AND STUD_SESSION_ID = :old.stud_session_id AND GDPR_SENT = 'N';
            ELSE
                INSERT INTO SGAS.BEN_GDPR (BEN_ID, STUD_SESSION_ID, STUD_REF_NO, GDPR_SENT, FLAGGED_FOR_LETTER, LETTER_SESSION) 
                VALUES (:new.ben2_id, NVL(:old.stud_session_id,:new.stud_session_id), NVL(:old.stud_ref_no,:new.stud_ref_no), 'N', SYSDATE, NVL(:new.SESSION_CODE,:old.SESSION_CODE));
            END IF;
           END IF;
END;
/


CREATE OR REPLACE TRIGGER SGAS.STS_IUD
   AFTER INSERT OR DELETE OR UPDATE OF ben1_id,
                                       ben2_id,
                                       emp_login_name,
                                       ja_case,
                                       loan_declaration_date,
                                       loan_request,
                                       max_loan_requested,
                                       net_income,
                                       pension_income,
                                       session_code,
                                       trust_income,
                                       ysb_entitlement,
                                       fee_loan_request_amount,
                                       max_fee_loan_requested,
                                       fee_loan_declaration_date,
                                       stud_hei_bursary_consent,
                                       reason_no_nino,
                                       slc1_fl_sent,
                                       slc1_fl_sent_date,
                                       lpcg_paid_amount,
                                       max_lpcg_paid,
                                       smg_entitlement,
                                       child_care_no,
                                       child_care_name,
                                       ben1_rel_id,
                                       ben2_rel_id,
                                       total_house_income,
                                       stud_income,
                                       care_leaver,
                                       date_applic_received,
                                       fee_loan_charged,
                                       session_suspend,
                                       last_updated_by,
                                       top_option,
                                       top_changed,
                                       debt_only
   ON SGAS.STUD_SESSION    REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
DECLARE
   p_aud_date          DATE                                 := SYSDATE;
   p_column_name       stud_session_aud.column_name%TYPE    := NULL;
   p_table_pkey1       stud_session_aud.table_pkey1%TYPE
                                            := TO_CHAR (:OLD.stud_session_id);
   p_table_pkey2       stud_session_aud.table_pkey2%TYPE    := NULL;
   p_table_pkey3       stud_session_aud.table_pkey3%TYPE    := NULL;
   p_table_pkey4       stud_session_aud.table_pkey4%TYPE    := NULL;
   p_table_pkey5       stud_session_aud.table_pkey5%TYPE    := NULL;
   p_old               stud_session_aud.OLD%TYPE            := NULL;
   p_new               stud_session_aud.NEW%TYPE            := NULL;
   p_action            stud_session_aud.action%TYPE         := NULL;
   p_username          stud_session_aud.username%TYPE := :NEW.last_updated_by;
   p_stud_ref_no       stud_session_aud.stud_ref_no%TYPE  := :OLD.stud_ref_no;
   p_inst_code         stud_session_aud.inst_code%TYPE      := NULL;
   p_session_code      stud_session_aud.session_code%TYPE
                                                         := :NEW.session_code;
   p_stud_session_id   stud_session.stud_session_id%TYPE
                                                      := :OLD.stud_session_id;
BEGIN
   IF INSERTING
   THEN
      p_action := 'I';
      p_table_pkey1 := :NEW.stud_session_id;
   ELSIF UPDATING
   THEN
      p_action := 'U';
   ELSIF DELETING
   THEN
      p_action := 'D';
      p_session_code := :OLD.session_code;
      p_stud_ref_no := :OLD.stud_ref_no;
      p_username := :OLD.last_updated_by;
   END IF;

   p_column_name := 'BEN1_ID';
   p_old := TO_CHAR (:OLD.ben1_id);
   p_new := TO_CHAR (:NEW.ben1_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_ID';
   p_old := TO_CHAR (:OLD.ben2_id);
   p_new := TO_CHAR (:NEW.ben2_id);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'EMP_LOGIN_NAME';
   p_old := :OLD.emp_login_name;
   p_new := :NEW.emp_login_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'JA_CASE';
   p_old := :OLD.ja_case;
   p_new := :NEW.ja_case;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_DECLARATION_DATE';
   p_old := :OLD.loan_declaration_date;
   p_new := :NEW.loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LOAN_REQUEST';
   p_old := TO_CHAR (:OLD.loan_request);
   p_new := TO_CHAR (:NEW.loan_request);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LOAN_REQUESTED';
   p_old := :OLD.max_loan_requested;
   p_new := :NEW.max_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'NET_INCOME';
   p_old := TO_CHAR (:OLD.net_income);
   p_new := TO_CHAR (:NEW.net_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'PENSION_INCOME';
   p_old := TO_CHAR (:OLD.pension_income);
   p_new := TO_CHAR (:NEW.pension_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SESSION_CODE';
   p_old := :OLD.session_code;
   p_new := :NEW.session_code;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TRUST_INCOME';
   p_old := TO_CHAR (:OLD.trust_income);
   p_new := TO_CHAR (:NEW.trust_income);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'YSB_ENTITLEMENT';
   p_old := :OLD.ysb_entitlement;
   p_new := :NEW.ysb_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_REQUEST_AMOUNT';
   p_old := :OLD.fee_loan_request_amount;
   p_new := :NEW.fee_loan_request_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_FEE_LOAN_REQUESTED';
   p_old := :OLD.max_fee_loan_requested;
   p_new := :NEW.max_fee_loan_requested;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_DECLARATION_DATE';
   p_old := :OLD.fee_loan_declaration_date;
   p_new := :NEW.fee_loan_declaration_date;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'FEE_LOAN_CHARGED';
   p_old := :OLD.fee_loan_charged;
   p_new := :NEW.fee_loan_charged;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_HEI_BURSARY_CONSENT';
   p_old := :OLD.stud_hei_bursary_consent;
   p_new := :NEW.stud_hei_bursary_consent;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'REASON_NO_NINO';
   p_old := TO_CHAR (:OLD.reason_no_nino);
   p_new := TO_CHAR (:NEW.reason_no_nino);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT';
   p_old := TO_CHAR (:OLD.slc1_fl_sent);
   p_new := TO_CHAR (:NEW.slc1_fl_sent);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SLC1_FL_SENT_DATE';
   p_old := TO_CHAR (:OLD.slc1_fl_sent_date);
   p_new := TO_CHAR (:NEW.slc1_fl_sent_date);
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LPCG_PAID_AMOUNT';
   p_old := :OLD.lpcg_paid_amount;
   p_new := :NEW.lpcg_paid_amount;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'MAX_LPCG_PAID';
   p_old := :OLD.max_lpcg_paid;
   p_new := :NEW.max_lpcg_paid;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SMG_ENTITLEMENT';
   p_old := :OLD.smg_entitlement;
   p_new := :NEW.smg_entitlement;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NO';
   p_old := :OLD.child_care_no;
   p_new := :NEW.child_care_no;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CHILD_CARE_NAME';
   p_old := :OLD.child_care_name;
   p_new := :NEW.child_care_name;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN1_REL_ID';
   p_old := :OLD.ben1_rel_id;
   p_new := :NEW.ben1_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'BEN2_REL_ID';
   p_old := :OLD.ben2_rel_id;
   p_new := :NEW.ben2_rel_id;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'TOTAL_HOUSE_INCOME';
   p_old := :OLD.total_house_income;
   p_new := :NEW.total_house_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'STUD_INCOME';
   p_old := :OLD.stud_income;
   p_new := :NEW.stud_income;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'CARE_LEAVER';
   p_old := :OLD.care_leaver;
   p_new := :NEW.care_leaver;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'DATE_APPLIC_RECEIVED';
   p_old := :OLD.date_applic_received;
   p_new := :NEW.date_applic_received;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'SESSION_SUSPEND';
   p_old := :OLD.session_suspend;
   p_new := :NEW.session_suspend;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
   p_column_name := 'LAST_UPDATED_BY';
   p_old := :OLD.last_updated_by;
   p_new := :NEW.last_updated_by;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
p_column_name := 'TOP_OPTION';
   p_old := :OLD.top_option;
   p_new := :NEW.top_option;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
p_column_name := 'TOP_CHANGED';
   p_old := :OLD.top_changed;
   p_new := :NEW.top_changed;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
p_column_name := 'DEBT_ONLY';
   p_old := :OLD.debt_only;
   p_new := :NEW.debt_only;
   pk_steps_aud.ins_sts_aud (p_aud_date,
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
END sts_iud;
/


DROP SEQUENCE SGAS.SUSPEND_SEQ;

CREATE SEQUENCE SGAS.SUSPEND_SEQ
  START WITH 43433
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
  NOKEEP
  NOSCALE
  GLOBAL;


CREATE OR REPLACE TRIGGER SGAS.TRIG_SUSPEND_SS
   AFTER UPDATE OF session_suspend
   ON SGAS.STUD_SESSION
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
   p_title          stud.title%TYPE;
   p_forenames      stud.forenames%TYPE;
   p_surname        stud.surname%TYPE;
   p_scheme_type    stud_crse_year.scheme_type%TYPE;
   p_inst_name      stud_crse_year.inst_name%TYPE;
   p_crse_name      stud_crse_year.crse_name%TYPE;
  
   
BEGIN
   IF UPDATING
   THEN
      IF (:new.session_suspend = 'Y')
      THEN

        
         SELECT s.title, s.forenames, s.surname
           INTO p_title, p_forenames, p_surname
           FROM stud s
          WHERE s.stud_ref_no = :old.stud_ref_no;

         SELECT 
                scy.scheme_type,
                scy.inst_name,
                scy.crse_name
           INTO 
                p_scheme_type,
                p_inst_name,
                p_crse_name
           FROM stud_crse_year scy
          WHERE     scy.stud_ref_no = :old.stud_ref_no
                AND SCY.SESSION_CODE = :old.session_code
                AND SCY.LATEST_CRSE_IND = 'Y';

         INSERT INTO SUSPEND
              VALUES (suspend_seq.NEXTVAL,
                      :OLD.stud_ref_no,
                      :NEW.last_updated_by,
                      :OLD.session_code,
                      SYSDATE,
                      'E',
                      p_inst_name,
                      p_crse_name,
                      p_scheme_type,
                      p_title,
                      p_forenames,
                      p_surname,
                      null);
      END IF;

      IF (:new.session_suspend = 'N')
      THEN
         DELETE FROM SUSPEND s
               WHERE     s.STUD_REF_NO = :old.stud_ref_no
                     AND s.suspend_level = 'E'
                     AND s.session_code = :old.session_code; /*JP190215 Added thisextra condition to fix defect 106 */
      END IF;
   END IF;
END;
/


ALTER TABLE SGAS.STUD_SESSION ADD (
  CONSTRAINT F1_STS 
  FOREIGN KEY (STUD_REF_NO) 
  REFERENCES SGAS.STUD (STUD_REF_NO)
  ENABLE VALIDATE
,  CONSTRAINT F2_STS 
  FOREIGN KEY (JA_CASE_ID) 
  REFERENCES SGAS.JA_CASE (JA_CASE_ID)
  ENABLE VALIDATE
,  CONSTRAINT F3_STS 
  FOREIGN KEY (BEN1_ID) 
  REFERENCES SGAS.BENEFACTOR (BEN_ID)
  ENABLE VALIDATE
,  CONSTRAINT F4_STS 
  FOREIGN KEY (BEN2_ID) 
  REFERENCES SGAS.BENEFACTOR (BEN_ID)
  ENABLE VALIDATE);

GRANT REFERENCES, SELECT ON SGAS.STUD_SESSION TO DMS_OWNER WITH GRANT OPTION;

GRANT SELECT ON SGAS.STUD_SESSION TO ILA500 WITH GRANT OPTION;

GRANT DELETE, SELECT ON SGAS.STUD_SESSION TO IN34;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO N310376;

GRANT DELETE, INSERT, SELECT, UPDATE ON SGAS.STUD_SESSION TO STEPS_SGAS_ROLE;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST10;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST11;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST12;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST2;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST3;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST4;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST5;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST6;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST7;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST8;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO STEPTEST9;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO TEST_TEAM_ROLE;

GRANT SELECT ON SGAS.STUD_SESSION TO TEST_TEAM_RO_ROLE;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U030026;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U200560;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U201385;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U201606;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U202949;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO U414558;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO Z605738;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO Z605739;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO Z607248;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO Z607878;

GRANT DELETE, INSERT, UPDATE ON SGAS.STUD_SESSION TO Z622960;
