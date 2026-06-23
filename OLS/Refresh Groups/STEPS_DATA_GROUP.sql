BEGIN
  DBMS_REFRESH.DESTROY(name => 'STEPS.STEPS_DATA_GROUP');
Commit;
END;
/

DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  SnapArray(1) := 'STEPS.BENEFACTOR';
  SnapArray(2) := 'STEPS.STUD';
  SnapArray(3) := 'STEPS.STUD_AWARD_STATUS';
  SnapArray(4) := 'STEPS.STUD_CONT_DETAILS';
  SnapArray(5) := 'STEPS.STUD_CRSE_YEAR';
  SnapArray(6) := 'STEPS.STUD_HOME_ADDR';
  SnapArray(7) := 'STEPS.STUD_MESSAGE';
  SnapArray(8) := 'STEPS.STUD_SESSION';
  SnapArray(9) := 'STEPS.STUD_TERM_ADDR';
  SnapArray(10) := 'STEPS.LEARNER';
  SnapArray(11) := 'STEPS.LEARNER_APPLICATION';
  SnapArray(12) := 'STEPS.AWARD_MSL';
  SnapArray(13) := 'STEPS.DSA_APPLICATION';
  SnapArray(14) := 'STEPS.DSA_ALLOWANCE';
  SnapArray(15) := 'STEPS.DSA_AWARD_NOTICE';
  SnapArray(16) := 'STEPS.DSA_AWARD_ITEMISED_DATA';
  SnapArray(17) := 'STEPS.DSA_AWARD_NMPH_DATA';
  SnapArray(18) := 'STEPS.DSA_AWARD_TRAVEL_DATA';
  SnapArray(19) := 'STEPS.DSA_AWARD_ACCOM_DATA';
  SnapArray(20) := NULL;
  SYS.DBMS_REFRESH.MAKE (
    name => 'STEPS.STEPS_DATA_GROUP'
    ,tab  => SnapArray
    ,next_date => SYSDATE
    ,interval  => 'SYSDATE + (5/60)/24'
    ,implicit_destroy => FALSE
    ,lax => TRUE
    ,job => 0
    ,rollback_seg => NULL
    ,push_deferred_rpc => TRUE
    ,refresh_after_errors => FALSE
    ,purge_option => 1
    ,parallelism => 0
    ,heap_size => 0
  );
Commit;
END;
/