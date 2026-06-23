-- STUD_RATE.sql
-- Description: Table holding all STUD Rates for SGAS
-- Author A.Bowman (SAAS) 
--
-- MODIFICATION HISTORY:
-- Ref      Date        Author                  Desc.
-- 1.0      11.11.09    A.Bowman (SAAS)         Initial Version.
-- 1.1      30.04.10    A.Bowman (SAAS)         Added foreign key references
-- 1.2      02.11.10    A.Bowman (SAAS)         Added unique constraint for stud_award_type_id and session_code
--
--
-- Configuration Management:
-- $HeadURL:  $
-- $Author: $
-- $Date:  $
-- $Revision: $

ALTER TABLE sgas.STUD_RATE
 DROP PRIMARY KEY CASCADE
/
DROP TABLE sgas.STUD_RATE CASCADE CONSTRAINTS PURGE
/
--
-- STUD_RATE  (Table) 
--
CREATE TABLE SGAS.STUD_RATE
(
  STUD_RATE_ID        NUMBER(10)                NOT NULL,
  STUD_AWARD_TYPE_ID  NUMBER(10)                NOT NULL,
  SESSION_CODE        NUMBER(4)                 NOT NULL,
  DISAB_BASIC_MAX     NUMBER(15,2)              DEFAULT 0,
  DISAB_NON_MED_MAX   NUMBER(15,2)              DEFAULT 0,
  DISAB_EQUIP_MAX     NUMBER(15,2)              DEFAULT 0,
  DISAB_TRAV_MAX      NUMBER(15,2)              DEFAULT 0,
  LAST_UPDATED_BY     VARCHAR2(15 BYTE)         DEFAULT USER                  NOT NULL,
  LAST_UPDATED_ON     DATE                      DEFAULT SYSDATE               NOT NULL,
  DISAB_ACCOM_MAX     NUMBER(15,2)
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

COMMENT ON TABLE SGAS.STUD_RATE IS 'The data and rates associated with a particular award type paid to a student';


CREATE UNIQUE INDEX SGAS.STUD_RATE_PK ON SGAS.STUD_RATE
(STUD_RATE_ID)
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
CREATE UNIQUE INDEX SGAS.STUD_RATE_U01 ON SGAS.STUD_RATE
(STUD_AWARD_TYPE_ID, SESSION_CODE)
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

ALTER TABLE SGAS.STUD_RATE ADD (
  CONSTRAINT STUD_RATE_PK
  PRIMARY KEY
  (STUD_RATE_ID)
  USING INDEX SGAS.STUD_RATE_PK
  ENABLE VALIDATE
,  CONSTRAINT STUD_RATE_U01
  UNIQUE (STUD_AWARD_TYPE_ID, SESSION_CODE)
  USING INDEX SGAS.STUD_RATE_U01
  ENABLE VALIDATE);


DROP SEQUENCE SGAS.STUD_RATE_ID_SEQ;

CREATE SEQUENCE SGAS.STUD_RATE_ID_SEQ
  START WITH 113
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
  NOKEEP
  NOSCALE
  GLOBAL;


CREATE OR REPLACE TRIGGER SGAS.TRIG_STUD_RATE_SEQ
   BEFORE INSERT
   ON SGAS.STUD_RATE
   FOR EACH ROW
BEGIN
   SELECT STUD_RATE_id_seq.NEXTVAL
     INTO :NEW.STUD_RATE_id
     FROM DUAL;
END;                                                            

--
-- INSERT DATA
--
/


CREATE OR REPLACE PUBLIC SYNONYM STUD_RATE FOR SGAS.STUD_RATE;


ALTER TABLE SGAS.STUD_RATE ADD (
  CONSTRAINT F1_STR 
  FOREIGN KEY (STUD_AWARD_TYPE_ID) 
  REFERENCES SGAS.STUD_AWARD_TYPE (STUD_AWARD_TYPE_ID)
  ENABLE VALIDATE);

-- 
-- Create public synonym: 
-- 
DROP PUBLIC SYNONYM STUD_RATE
/
CREATE PUBLIC SYNONYM STUD_RATE FOR sgas.STUD_RATE
/
DROP SEQUENCE sgas.STUD_RATE_id_seq
/
--
-- STUD_RATE_ID_seq  (Sequence) 
--
CREATE SEQUENCE sgas.STUD_RATE_id_seq
  START WITH 1
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER
/
CREATE OR REPLACE TRIGGER sgas.trig_STUD_RATE_seq
   BEFORE INSERT
   ON SGAS.STUD_RATE
   FOR EACH ROW
BEGIN
   SELECT STUD_RATE_id_seq.NEXTVAL
     INTO :NEW.STUD_RATE_id
     FROM DUAL;
END;                                                            

--
-- INSERT DATA
--

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (32, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (34, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (37, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (43, 2009 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (32, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (34, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (37, 2010 
            );

INSERT INTO stud_rate
            (stud_award_type_id, session_code
            )
     VALUES (43, 2010 
            );

COMMIT;
