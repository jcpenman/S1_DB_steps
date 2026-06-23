CREATE OR REPLACE PACKAGE BODY SGAS.pk_steps_ui_dsa
AS
/******************************************************************************
   NAME:       pk_steps_ui_DSA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author                    Description
   ---------  ----------  ---------------           ------------------------------------
   1.0        17/11/2008    PADDY GRACE           Created this package.
   1.1        13/10/2009    ABIRAMI CHIDAMBARAM   Code Population
   1.2        20/06/2014    Ranj Benning          StEPS Defect 02 - Fix to procedure updatePayment
******************************************************************************/
   PROCEDURE insertdefaultdsaapplication (
      stud_ref_no_in          IN              VARCHAR2,
      session_code_in         IN              VARCHAR2,
      last_updated_by_in      IN              VARCHAR2,
      error_boolean           OUT NOCOPY      VARCHAR2,
      ERROR_TEXT              OUT NOCOPY      VARCHAR2,
      row_count               OUT             NUMBER,
      dsaapplication_id_out   OUT             VARCHAR2
   )
   IS
      temp_pkey   NUMBER (10);
   BEGIN
      INSERT INTO dsa_application
                  (ID, stud_ref_no,
                   session_code, last_updated_by, last_updated_on
                  )
           VALUES (dsa_application_id_seq.NEXTVAL, stud_ref_no_in,
                   session_code_in, UPPER (last_updated_by_in), SYSDATE
                  );

      SELECT dsa_application.ID
        INTO temp_pkey
        FROM dsa_application
       WHERE stud_ref_no = stud_ref_no_in AND session_code = session_code_in;

      row_count := SQL%ROWCOUNT;
      dsaapplication_id_out := temp_pkey;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END insertdefaultdsaapplication;

   PROCEDURE getpersonaldetails (
      stud_ref_no_in    IN              NUMBER,
      session_code_in   IN              NUMBER,
      io_cursor         IN OUT          personaldetails_cursor,
      error_boolean     OUT NOCOPY      VARCHAR2,
      ERROR_TEXT        OUT NOCOPY      VARCHAR2
   )
   IS
      pd_cursor   personaldetails_cursor;
   BEGIN
      OPEN pd_cursor FOR
         SELECT da.ID AS id_out,
                da.disability_type_id AS disability_type_id_out,
                da.date_application_received
                                            AS date_application_received_out,
                da.priority_app AS priortiy_app_out,
                da.referred_flag AS referred_flag_out,
                da.date_referred_access_centre AS date_ref_access_centre_out,
                da.dsa_referral_reason_id AS dsa_referral_reason_id_out,
                da.assessment_centre_id AS assessment_centre_id_out,
                da.rejected AS rejected_out,
                da.dsa_rejection_reason_id AS dsa_rejection_reason_id_out,
                da.consent_ticked AS consent_ticked_out,
                da.other_information AS other_information_out,
                da.dsa_student_type_id AS dsa_student_type_id_out,
                da.part_time_course AS part_time_course_out,
                da.needs_assessor AS needs_assessor_out,
                da.date_assess_rep_received AS date_assess_rep_received_out,
                da.date_assess_rep_processed
                                            AS date_assess_rep_processed_out,
                da.assessor_hourly_rate AS assessor_hourly_rate_out,
                da.processing_days AS processing_days_out,
                da.assess_fee_amount AS assess_fee_amount_out,
                da.more_info_req AS more_info_req_out,
                da.exceptional_case AS exceptional_case_out,
                rej_r.reason AS rejection_reason_out,
                ac.name AS assessment_centre_out,
                dt.descript AS disability_type_out,
                ref_r.reason AS referral_reason_out,
                st.type AS student_type_out,
                da.dsa_app_status AS dsa_app_status_out,
                da.is_online AS is_online_out,
                da.dis_hearing_impairment AS dis_hearing_impairment_out,    
                da.dis_learning_difficulty AS dis_learning_difficulty_out,    
                da.dis_long_standing_illness AS dis_long_standing_illness_out,    
                da.dis_mental_health_cond AS dis_mental_health_cond_out,    
                da.dis_phys_impairment AS dis_phys_impairment_out,    
                da.dis_soc_or_comms_impairment AS dis_soc_or_comms_impairment_out,
                da.dis_visual_impairment AS dis_visual_impairment_out,    
                da.dis_not_listed AS dis_not_listed_out,    
                da.dis_other_disability    AS dis_other_disability_out,
                da.extension_end_date AS extension_end_date_out
           FROM dsa_application da,
                dsa_rejection_reason rej_r,
                dsa_assessment_centre ac,
                disability_type dt,
                dsa_referral_reason ref_r,
                dsa_student_type st
          WHERE da.stud_ref_no = stud_ref_no_in
            AND da.session_code = session_code_in
            AND da.dsa_rejection_reason_id = rej_r.dsa_rejection_reason_id (+)
            AND da.assessment_centre_id = ac.dsa_assessment_centre_id (+)
            AND da.disability_type_id = dt.disability_type_id (+)
            AND da.dsa_referral_reason_id = ref_r.dsa_referral_reason_id (+)
            AND da.dsa_student_type_id = st.dsa_student_type_id (+);

      io_cursor := pd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpersonaldetails;

   PROCEDURE setpersonaldetails (
      dsa_app_id_in                  IN       VARCHAR2,
      disability_type_id_in          IN       VARCHAR2,
      date_application_received_in   IN       DATE,
      priortiy_app_in                IN       VARCHAR2,
      referred_flag_in               IN       VARCHAR2,
      date_ref_access_centre_in      IN       DATE,
      dsa_referral_reason_id_in      IN       VARCHAR2,
      assessment_centre_id_in        IN       VARCHAR2,
      rejected_in                    IN       VARCHAR2,
      dsa_rejection_reason_id_in     IN       VARCHAR2,
      consent_ticked_in              IN       VARCHAR2,
      other_information_in           IN       VARCHAR2,
      dsa_student_type_id_in         IN       VARCHAR2,
      part_time_course_in            IN       VARCHAR2,
      needs_assessor_in              IN       VARCHAR2,
      date_assess_rep_received_in    IN       DATE,
      date_assess_rep_processed_in   IN       DATE,
      assessor_hourly_rate_in        IN       VARCHAR2,
      processing_days_in             IN       VARCHAR2,
      assess_fee_amount_in           IN       VARCHAR2,
      more_info_req_in               IN       VARCHAR2,
      exceptional_case_in            IN       VARCHAR2,
      dsa_app_status_in                 IN       VARCHAR2,
      is_online_in                      IN       VARCHAR2,
      dis_hearing_impairment_in      IN       VARCHAR2,          
      dis_learning_difficulty_in     IN       VARCHAR2,      
      dis_long_standing_illness_in     IN       VARCHAR2,      
      dis_mental_health_cond_in          IN       VARCHAR2,      
      dis_phys_impairment_in          IN       VARCHAR2,      
      dis_soc_or_comms_impairment_in IN       VARCHAR2,      
      dis_visual_impairment_in          IN       VARCHAR2,      
      dis_not_listed_in                  IN       VARCHAR2,      
      dis_other_disability_in         IN       VARCHAR2,          
      extension_end_date_in             IN          DATE,      
      user_in                        IN       VARCHAR2,
      error_boolean                  OUT      VARCHAR2,
      ERROR_TEXT                     OUT      VARCHAR2,
      row_count_da                   OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE dsa_application
         SET disability_type_id = disability_type_id_in,
             date_application_received = date_application_received_in,
             priority_app = UPPER (priortiy_app_in),
             referred_flag = UPPER (referred_flag_in),
             date_referred_access_centre = date_ref_access_centre_in,
             dsa_referral_reason_id = dsa_referral_reason_id_in,
             assessment_centre_id = assessment_centre_id_in,
             rejected = UPPER (rejected_in),
             dsa_rejection_reason_id = dsa_rejection_reason_id_in,
             consent_ticked = UPPER (consent_ticked_in),
             other_information = UPPER (other_information_in),
             dsa_student_type_id = dsa_student_type_id_in,
             part_time_course = part_time_course_in,
             needs_assessor = UPPER (needs_assessor_in),
             date_assess_rep_received = date_assess_rep_received_in,
             date_assess_rep_processed = date_assess_rep_processed_in,
             assessor_hourly_rate = assessor_hourly_rate_in,
             processing_days = processing_days_in,
             assess_fee_amount = assess_fee_amount_in,
             more_info_req = UPPER (more_info_req_in),
             exceptional_case = UPPER (exceptional_case_in),
             dsa_app_status = dsa_app_status_in,
             is_online = UPPER(is_online_in),
             dis_hearing_impairment = UPPER (dis_hearing_impairment_in),
             dis_learning_difficulty = UPPER (dis_learning_difficulty_in),    
             dis_long_standing_illness = UPPER (dis_long_standing_illness_in),    
             dis_mental_health_cond = UPPER (dis_mental_health_cond_in),    
             dis_phys_impairment = UPPER (dis_phys_impairment_in),    
             dis_soc_or_comms_impairment = UPPER (dis_soc_or_comms_impairment_in),    
             dis_visual_impairment = UPPER (dis_visual_impairment_in),    
             dis_not_listed = UPPER (dis_not_listed_in),    
             dis_other_disability = dis_other_disability_in,    
             extension_end_date = extension_end_date_in,                 
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE ID = dsa_app_id_in;

      row_count_da := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count_da := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setpersonaldetails;

   PROCEDURE getallowancesummary (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancesummary_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      as_cursor   allowancesummary_cursor;
   BEGIN
      OPEN as_cursor FOR
         SELECT 1 TYPE,
                NVL ((SUM (DECODE (dc.type_id, 1, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 1, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 1, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_session_id IN (
                   SELECT ss.stud_session_id
                     FROM stud_session ss
                    WHERE ss.stud_ref_no =
                             (SELECT scy.stud_ref_no
                                FROM stud_crse_year scy
                               WHERE scy.stud_crse_year_id =
                                                         stud_crse_year_id_in))
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 2,
                NVL ((SUM (DECODE (dc.type_id, 2, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 2, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 2, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 3,
                NVL ((SUM (DECODE (dc.type_id, 3, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 3, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 3, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 4,
                NVL ((SUM (DECODE (dc.type_id, 4, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 4, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 4, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+)
         UNION
         SELECT 5,
                NVL ((SUM (DECODE (dc.type_id, 5, da.max_amount, 0))),
                     0
                    ) AS max_amount,
                NVL ((SUM (DECODE (dc.type_id, 5, da.paid_amount, 0))),
                     0
                    ) AS paid_amount,
                NVL ((SUM (DECODE (dc.type_id, 5, da.available_amount, 0))),
                     0
                    ) AS available_amount
           FROM dsa_allowance da, dsa_category dc
          WHERE da.stud_crse_year_id = stud_crse_year_id_in
            AND da.dsa_category_id = dc.dsa_category_id(+);

      io_cursor := as_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancesummary;

   PROCEDURE getallowancedetails (
      stud_crse_year_id_in   IN              NUMBER,
      io_cursor              IN OUT          allowancedetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      ad_cursor   allowancedetails_cursor;
   BEGIN
      OPEN ad_cursor FOR
      SELECT da.ID AS allowance_id_out,
               da.dsa_category_id AS category_id_out,
               da.max_amount AS max_amt_out,
               da.paid_amount AS paid_amt_out,
               da.available_amount AS available_amt_out
               --da.nmph_hours AS nmph_hours_out,
               --da.nmph_hourly_rate AS nmph_hourly_rate_out,
               --da.nmph_weeks AS nmph_weeks_out,
               --da.nmph_recommended_provider AS nmph_recommended_provider_out
          FROM dsa_allowance da
         WHERE da.stud_crse_year_id = stud_crse_year_id_in
        UNION
        SELECT da.ID AS allowance_id_out,
               da.dsa_category_id AS category_id_out,
               da.max_amount AS max_amt_out,
               da.paid_amount AS paid_amt_out,
               da.available_amount AS available_amt_out
               --da.nmph_hours AS nmph_hours_out,
               --da.nmph_hourly_rate AS nmph_hourly_rate_out,
               --da.nmph_weeks AS nmph_weeks_out,
               --da.nmph_recommended_provider AS nmph_recommended_provider_out               
          FROM dsa_allowance da
         WHERE da.dsa_category_id IN
                  (SELECT dc.dsa_category_id
                     FROM dsa_category dc, dsa_type dt
                    WHERE dc.type_id = dt.dsa_type_id AND dt.code = 'LRG')
               AND da.stud_session_id IN
                      (SELECT ss.stud_session_id
                         FROM stud_session ss
                        WHERE ss.stud_ref_no =
                                 (SELECT scy.stud_ref_no
                                    FROM stud_crse_year scy
                                   WHERE scy.stud_crse_year_id =
                                            stud_crse_year_id_in))
        ORDER BY 2;
    
      io_cursor := ad_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancedetails;

   PROCEDURE insertallowancedetails (
      application_id_in              IN       NUMBER,
      stud_session_id_in             IN       NUMBER,
      stud_crse_year_id_in           IN       NUMBER,
      category_id_in                 IN       NUMBER,
      max_amt_in                     IN       NUMBER,
      overridetype_in                IN       VARCHAR2,
      overridedsa_in                 IN       VARCHAR2,
      user_in                        IN       VARCHAR2,
      nmph_hours_in                  IN       NUMBER,
      nmph_hourly_rate_in            IN       NUMBER,
      nmph_weeks_in                  IN       NUMBER,
      nmph_recommended_provider_in   IN       VARCHAR2,
      travel_journeys_in             IN       NUMBER,
      travel_costs_in                IN       NUMBER,
      travel_weeks_in                IN       NUMBER,
      travel_recommended_provider_in IN       VARCHAR2,
      travel_provider_id_in          IN       NUMBER,   
      nmph_type_of_support_in        IN       VARCHAR2,
      is_itemised_in                 IN       VARCHAR2,
      start_postcode_in              IN       VARCHAR2, 
      end_postcode_in                IN       VARCHAR2,    
      pay_hei_in                     IN       VARCHAR2, 
      nmph_max_restricted_in         IN       VARCHAR2, 
      accom_standard_in              IN       NUMBER,
      accom_enhanced_in              IN       NUMBER,
      accom_weeks_in                 IN       NUMBER,      
      error_boolean                  OUT      VARCHAR2,
      ERROR_TEXT                     OUT      VARCHAR2,
      row_count                      OUT      VARCHAR2
   )
   AS
   BEGIN
      INSERT INTO dsa_allowance dsaa
                  ( dsaa.dsa_application_id,
                   dsaa.stud_session_id, dsaa.stud_crse_year_id,
                   dsaa.dsa_category_id, dsaa.max_amount, dsaa.general_override_limit, dsaa.statutory_override_limit, 
                   dsaa.paid_amount,dsaa.available_amount, dsaa.last_updated_by,
                   dsaa.last_updated_on,
                   dsaa.nmph_hours, dsaa.nmph_hourly_rate, dsaa.nmph_weeks, dsaa.nmph_recommended_provider,
                   dsaa.travel_journeys, dsaa.travel_costs, dsaa.travel_weeks, dsaa.travel_recommended_provider, dsaa.travel_provider_id,
                   dsaa.nmph_type_of_support, dsaa.itemised, dsaa.start_postcode, dsaa.end_postcode, DSAA.PAY_HEI, DSAA.NMPH_MAX_RESTRICTED,
                   DSAA.ACCOM_STANDARD_COST, DSAA.ACCOM_ENHANCED_COST, DSAA.ACCOM_WEEKS
                  )
           VALUES ( application_id_in,
                   stud_session_id_in, stud_crse_year_id_in,
                   category_id_in, max_amt_in, overridedsa_in, overridetype_in,  
                    '0',max_amt_in, UPPER (user_in),
                   SYSDATE,
                   nmph_hours_in, nmph_hourly_rate_in, nmph_weeks_in, nmph_recommended_provider_in,
                   travel_journeys_in, travel_costs_in, travel_weeks_in, travel_recommended_provider_in, travel_provider_id_in,
                   nmph_type_of_support_in, is_itemised_in, start_postcode_in, end_postcode_in, pay_hei_in, nmph_max_restricted_in,
                   accom_standard_in, accom_enhanced_in, accom_weeks_in
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END insertallowancedetails;

   PROCEDURE countduplicatecategories (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   countduplicates_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      cd_cursor   countduplicates_cursor;
   BEGIN
      OPEN cd_cursor FOR
          SELECT x.dsa_category_id AS category_id,
                 COUNT (x.dsa_category_id) AS countcat
            FROM (SELECT da.id, da.dsa_category_id
                    FROM dsa_allowance da
                   WHERE da.stud_crse_year_id = stud_crse_year_id_in
                  UNION
                  SELECT da.id, da.dsa_category_id
                    FROM dsa_allowance da
                   WHERE (    da.dsa_category_id IN (SELECT dc.dsa_category_id
                                                       FROM dsa_category dc,
                                                            dsa_type dt
                                                      WHERE     dc.type_id =
                                                                   dt.dsa_type_id
                                                            AND dt.code = 'LRG')
                          AND da.stud_session_id IN (SELECT ss.stud_session_id
                                                       FROM stud_session ss
                                                      WHERE ss.stud_ref_no =
                                                               (SELECT scy.stud_ref_no
                                                                  FROM stud_crse_year scy
                                                                 WHERE scy.stud_crse_year_id =
                                                                          stud_crse_year_id_in))))
                 x
            GROUP BY x.dsa_category_id;

      io_cursor := cd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END countduplicatecategories;

   PROCEDURE showallowancerecord (
      stud_crse_year_id_in   IN              NUMBER,
      type_id_in             IN              VARCHAR2,
      io_cursor              IN OUT          allowancerecord_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      ar_cursor      allowancerecord_cursor;
      temp_type_id   NUMBER;
   BEGIN
      SELECT dt.dsa_type_id
        INTO temp_type_id
        FROM dsa_type dt
       WHERE UPPER (dt.TYPE) = UPPER (type_id_in);

      IF temp_type_id = 1
      THEN
         OPEN ar_cursor FOR
            SELECT da.ID AS id_out, 
                   da.dsa_category_id AS category_id_out,
                   da.max_amount AS max_amount_out, 
                   da.nmph_hours as nmph_hours_out,
                   da.nmph_hourly_rate as nmph_hourly_rate_out,
                   da.nmph_weeks as nmph_weeks_out,
                   da.nmph_recommended_provider as nmph_recommended_provider_out,
                   da.travel_journeys as travel_journeys_out,
                   da.travel_costs as travel_costs_out,
                   da.travel_weeks as travel_weeks_out,
                   da.travel_recommended_provider as travel_recommended_provider_out,
                   da.travel_provider_id as travel_provider_id_out,
                   da.nmph_type_of_support as nmph_type_of_support_out,  
                   da.start_postcode as travel_start_postcode_out,
                   da.end_postcode as travel_end_postcode_out,
                   DA.PAY_HEI as pay_hei_out,
                   DA.NMPH_MAX_RESTRICTED as nmph_max_restricted
              FROM dsa_allowance da, dsa_category dc
             WHERE (    da.dsa_category_id IN (
                           SELECT dc.dsa_category_id
                             FROM dsa_category dc, dsa_type dt
                            WHERE dc.type_id = dt.dsa_type_id
                              AND dt.code = 'LRG')
                    AND da.stud_session_id IN (
                           SELECT ss.stud_session_id
                             FROM stud_session ss
                            WHERE ss.stud_ref_no =
                                     (SELECT scy.stud_ref_no
                                        FROM stud_crse_year scy
                                       WHERE scy.stud_crse_year_id =
                                                          stud_crse_year_id_in))
                   )
               AND da.dsa_category_id = dc.dsa_category_id;
      ELSE
         OPEN ar_cursor FOR
            SELECT da.ID AS id_out, 
                   da.dsa_category_id AS category_id_out,
                   da.max_amount AS max_amount_out,                   
                   da.nmph_hours as nmph_hours_out,
                   da.nmph_hourly_rate as nmph_hourly_rate_out,
                   da.nmph_weeks as nmph_weeks_out,
                   da.nmph_recommended_provider as nmph_recommended_provider_out,
                   da.travel_journeys as travel_journeys_out,
                   da.travel_costs as travel_costs_out,
                   da.travel_weeks as travel_weeks_out,
                   da.travel_recommended_provider as travel_recommended_provider_out,
                   da.travel_provider_id as travel_provider_id_out,
                   da.nmph_type_of_support as nmph_type_of_support_out,
                   da.start_postcode as travel_start_postcode_out,
                   da.end_postcode as travel_end_postcode_out,
                   DA.PAY_HEI as pay_hei_out,
                   DA.NMPH_MAX_RESTRICTED as nmph_max_restricted_out,
                   DA.ACCOM_STANDARD_COST as accom_standard_cost_out,
                   DA.ACCOM_ENHANCED_COST as accom_enhanced_cost_out,
                   DA.ACCOM_WEEKS as accom_weeks_out
              FROM dsa_allowance da, dsa_category dc
             WHERE da.dsa_category_id = dc.dsa_category_id
               AND da.stud_crse_year_id = stud_crse_year_id_in
               AND dc.type_id = temp_type_id;
      END IF;

      io_cursor := ar_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END showallowancerecord;

   PROCEDURE setallowancedetails (
      dsa_all_id_in                   IN       NUMBER,
      category_in                     IN       VARCHAR2,
      max_amt_in                      IN       NUMBER,
      user_in                         IN       VARCHAR2,
      --nmph_hours_in                  IN         NUMBER,
      --nmph_hourly_rate_in             IN         NUMBER,
      --nmph_weeks_in                     IN         NUMBER,
      --nmph_recommended_provider_in     IN          VARCHAR2,          
      error_boolean                   OUT      VARCHAR2,
      ERROR_TEXT                      OUT      VARCHAR2,
      row_count_da                    OUT      VARCHAR2
   )
   IS
      temp_cat_id   NUMBER;
   BEGIN
      SELECT dc.dsa_category_id
        INTO temp_cat_id
        FROM dsa_category dc
       WHERE UPPER (dc.description) = UPPER (category_in);

      UPDATE dsa_allowance
         SET dsa_category_id = temp_cat_id,
             max_amount = max_amt_in,
             paid_amount = '0',
             available_amount = max_amt_in,             
             --nmph_hours = nmph_hours_in,
             --nmph_hourly_rate = nmph_hourly_rate_in,
             --nmph_weeks = nmph_weeks_in,
             --nmph_recommended_provider = nmph_recommended_provider_in,             
             last_updated_by = UPPER (user_in),
             last_updated_on = SYSDATE
       WHERE ID = dsa_all_id_in;

      row_count_da := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count_da := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END setallowancedetails;

   PROCEDURE deleteallowancedetails (
      id_in           IN              NUMBER,
      employee_in     IN              VARCHAR2,
      error_boolean   OUT NOCOPY      VARCHAR2,
      ERROR_TEXT      OUT NOCOPY      VARCHAR2,
      row_count       OUT             VARCHAR2
   )
   IS
   BEGIN
      UPDATE dsa_allowance da
         SET da.last_updated_by = UPPER (employee_in)
       WHERE da.ID = id_in;

      DELETE FROM dsa_allowance da
            WHERE da.ID = id_in;

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         row_count := '0';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END deleteallowancedetails;

   PROCEDURE getstudnominees (
      stud_ref_no_in   IN              VARCHAR2,
      io_cursor        IN OUT          nomineesselected_cursor,
      error_boolean    OUT NOCOPY      VARCHAR2,
      ERROR_TEXT       OUT NOCOPY      VARCHAR2
   )
   IS
      nom_cursor   nomineesselected_cursor;
   BEGIN
      OPEN nom_cursor FOR
         SELECT   nom.nominee_id, nom.forename, nom.surname,
                  nom.company_name, nom.house_no_name, nom.addr_l1,
                  nom.addr_l2, nom.addr_l3, nom.addr_l4, nom.post_code,
                  nom.telephone_no, nom.account_no, nom.sort_code,
                  nom.payment_method, nom.last_updated_by,
                  TO_CHAR
                         (TO_DATE (nom.last_updated_on,
                                   'DD-MM-YYYY HH12:MI:SS'
                                  )
                         ) AS last_updated_on
             FROM nominee nom, stud_nominee s
            WHERE s.stud_ref_no = stud_ref_no_in
              AND s.nominee_id = nom.nominee_id
         ORDER BY nom.nominee_id DESC;

      error_boolean := 'false';
      io_cursor := nom_cursor;
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstudnominees;

   PROCEDURE insertstudnominee (
      stud_ref_no_in       IN              VARCHAR2,
      nominee_id_in        IN              VARCHAR2,
      last_updated_by_in   IN              VARCHAR2,
      error_boolean        OUT NOCOPY      VARCHAR2,
      ERROR_TEXT           OUT NOCOPY      VARCHAR2,
      row_count            OUT             NUMBER
   )
   IS
   BEGIN
      INSERT INTO stud_nominee
                  (stud_ref_no, nominee_id,
                   last_updated_by, last_updated_on
                  )
           VALUES (stud_ref_no_in, nominee_id_in,
                   UPPER (last_updated_by_in), SYSDATE
                  );

      row_count := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         row_count := 0;
   END insertstudnominee;

   PROCEDURE getpaymentdetails (
      stud_crse_year_id_in   IN              VARCHAR2,
      io_cursor              IN OUT          paymentdetails_cursor,
      error_boolean          OUT NOCOPY      VARCHAR2,
      ERROR_TEXT             OUT NOCOPY      VARCHAR2
   )
   IS
      pd_cursor         paymentdetails_cursor;
      temp_payee_type   VARCHAR2 (10);
   BEGIN
      OPEN pd_cursor FOR
         SELECT dsap.ID AS ID, dsap.award_instalment_id,
                dsap.dsa_allowance_id,
                DECODE (dsap.payee_type,
                        'S', 'Student',
                        'N', 'Nominee'
                       ) AS payee_type,
                dsap.payee_id, dsap.amount, dsap.payment_method_id,
                dsap.batch_date, dsap.process_date,
                dsap.dsa_payment_status_id, dsap.payment_type,
                dsap.batch_ref, dsap.re_issue_flag, dsap.amount_rate,
                dsap.REFERENCE, dsap.period_start_date, dsap.period_end_date,
                dsap.receipt_required, dsap.receipt_received,
                dsap.receipt_amount, dsap.invoice_ref, dsap.notes,
                dsap.last_updated_by, dsap.last_updated_on, dsac.description AS category,
                awi.payment_status
           FROM dsa_payment dsap, dsa_allowance dsaa, dsa_category dsac, award_instalment awi 
          WHERE dsap.dsa_allowance_id = dsaa.ID
            AND dsaa.stud_crse_year_id = stud_crse_year_id_in
            AND dsaa.dsa_category_id = dsac.dsa_category_id 
            AND dsap.award_instalment_id = awi.award_instalment_id 
            order by DSAP.ID ;

      io_cursor := pd_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getpaymentdetails;

   PROCEDURE getallowancepayments (
      stud_crse_year_id_in   IN       VARCHAR2,
      io_cursor              IN OUT   allowancepayment_cursor,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   AS
      ap_cursor   allowancepayment_cursor;
   BEGIN
      OPEN ap_cursor FOR
         SELECT da.ID AS id_out, dt.TYPE AS type_out,
                dt.dsa_type_id AS type_id_out,
                da.dsa_category_id AS category_id_out,
                dc.description AS category_desc_out,
                da.payment_due_date AS payment_due_date_out,
                da.travel_amount AS travel_amount_out
           FROM dsa_allowance da, dsa_category dc, dsa_type dt
          WHERE dc.dsa_category_id = da.dsa_category_id
            AND dt.dsa_type_id = dc.type_id
            AND da.stud_crse_year_id = stud_crse_year_id_in;

      io_cursor := ap_cursor;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getallowancepayments;

   PROCEDURE processreceipt (
      stud_award_type_in               IN       VARCHAR2,
      stud_award_type_description_in   IN       VARCHAR2,
      stud_crse_year_id_in             IN       VARCHAR2,
      dsa_allowance_id_in              IN       VARCHAR2,
      nominee_id_in                    IN       VARCHAR2,
      payee_type_in                    IN       VARCHAR2,
      payee_id_in                      IN       VARCHAR2,
      amount_in                        IN       VARCHAR2,
      reference_in                     IN       VARCHAR2,
      amount_rate_in                   IN       VARCHAR2,
      period_in                        IN       VARCHAR2,
      travel_element_in                IN       VARCHAR2,
      due_date_in                      IN       DATE,
      invoice_ref_in                   IN       VARCHAR2,
      notes_in                         IN       VARCHAR2,
      receipt_required_in              IN       VARCHAR2,
      receipt_received_in              IN       VARCHAR2,
      receipt_amount_in                IN       VARCHAR2,
      period_start_date_in             IN       DATE,
      period_end_date_in               IN       DATE,
      payment_type_in                  IN       VARCHAR2,
      employee_in                      IN       VARCHAR2,
      error_boolean                    OUT      VARCHAR2,
      ERROR_TEXT                       OUT      VARCHAR2
   )
   AS
      temp_stud_ref_no           VARCHAR2 (20);
      temp_stud_session          VARCHAR2 (20);
      temp_inst_code             VARCHAR2 (20);
      temp_crse_id               VARCHAR2 (20);
      temp_crse_year_no          VARCHAR2 (20);
      temp_net_amount            VARCHAR2 (8);
      temp_current_session       VARCHAR2 (5);
      temp_payment_method        VARCHAR2 (1);
      temp_dsa_payment_method    NUMBER (10);
      temp_payment_addr          VARCHAR2 (1);
      temp_campus_id             VARCHAR2 (1);
      temp_fees_campus           VARCHAR2 (10);
      temp_award_id              NUMBER (10);
      temp_award_instalment_id   NUMBER (10);
   BEGIN
      ERROR_TEXT := 'Getting current session ';

      SELECT cval
        INTO temp_current_session
        FROM config_data
       WHERE item_name = 'CURRENT_SESSION';

      ERROR_TEXT := 'Getting stud session and stud ref no ';

      /*
      *    Get supporting information for inserts
      */
      SELECT scy.stud_session_id, scy.stud_ref_no
        INTO temp_stud_session, temp_stud_ref_no
        FROM stud_crse_year scy
       WHERE scy.stud_crse_year_id = stud_crse_year_id_in;

      ERROR_TEXT := 'Getting course details ';

      SELECT scy.inst_code, scy.crse_id, scy.crse_year_no
        INTO temp_inst_code, temp_crse_id, temp_crse_year_no
        FROM stud_crse_year scy
       WHERE scy.stud_session_id = temp_stud_session
         AND scy.latest_crse_ind = 'Y';

      IF payee_type_in = 'S'
      THEN
         ERROR_TEXT := 'Getting payment method for student ';

         SELECT s.payment_method
           INTO temp_payment_method
           FROM stud s
          WHERE s.stud_ref_no = temp_stud_ref_no;

         IF temp_payment_method = 'B'
         THEN
            temp_payment_addr := 'B';
         ELSE
            temp_payment_addr := 'H';
         END IF;
      ELSE
         ERROR_TEXT := 'Getting payment method for nominee ';

         SELECT pm.legacy_code
           INTO temp_payment_method
           FROM nominee n, payment_method pm
          WHERE n.nominee_id = nominee_id_in
            AND n.payment_method = pm.payment_method_id;

         IF temp_payment_method = 'B'
         THEN
            temp_payment_addr := 'B';
         ELSE
            temp_payment_addr := 'N';
         END IF;
      END IF;

      ERROR_TEXT := 'Determining if fees campus relevant ';

      IF temp_payment_method = 'C'
      THEN
         temp_campus_id := temp_fees_campus;
      ELSE
         temp_campus_id := NULL;
      END IF;

      ERROR_TEXT := ' Getting payment method ';

      SELECT pm.payment_method_id
        INTO temp_dsa_payment_method
        FROM payment_method pm
       WHERE pm.legacy_code = temp_payment_method;

      ERROR_TEXT := 'Getting next award id from sequence ';    

      SELECT sgas.aw_award_id_seq.NEXTVAL
        INTO temp_award_id
        FROM DUAL;

       temp_net_amount := amount_in - travel_element_in;

      /*
       *    Depending on receipt being money coming in or going out, branch and update
       *     dsa_allowance records accordingly
       */
      IF payment_type_in = 'PAYMENT'
      THEN
         ERROR_TEXT := 'Inserting award record ';       

         /*
          *    Insert Award record
          */
          INSERT INTO award a
                     (a.award_id, a.stud_crse_year_id, a.inst_code,
                      a.crse_id, a.award_src, a.dsa_allowance_id,
                      a.non_tuition_fee_id, a.tuition_fee_type_code,
                      a.stud_award_type, a.award_type_descript,
                      a.stud_ref_no, a.session_code,
                      a.crse_year_no, a.assessment_date,
                      a.assess_reason_code, a.amount, a.net_amount,
                      a.contrib_amount, a.recovered_amount,
                      a.overpayment_amount, a.auto_travel_amount,
                      a.trav_amount, a.hold, a.overpaid_contrib, a.zero_da,
                      a.unclaimed_loan, a.online_award_payment_hold_flag,
                      a.paid_as_claimed_fg, a.travel_award_type,
                      a.unclaimed_fee_loan
                     )
              VALUES (temp_award_id, stud_crse_year_id_in, temp_inst_code,
                      temp_crse_id, 'A', dsa_allowance_id_in,
                      NULL, NULL,
                      stud_award_type_in, stud_award_type_description_in,
                      temp_stud_ref_no, temp_current_session,
                      temp_crse_year_no, SYSDATE,
                      'M', amount_in, temp_net_amount,
                      0, 0,
                      0, NULL,
                      travel_element_in, 'N', NULL, NULL,
                      NULL, NULL,
                      NULL, NULL,
                      NULL
                     );                          

         ERROR_TEXT := 'Inserting award instalment record ';

         /*
          *    Insert Award Instalment record
          */
         INSERT INTO award_instalment ai
                     (ai.award_id, ai.payment_due_date, ai.install_type,
                      ai.assessment_date, ai.amount, ai.recovered_amount,
                      ai.contrib_amount, ai.net_amount, ai.method, ai.payee,
                      ai.payment_addr, ai.campus_id, ai.payment_status,
                      ai.batch_ref, ai.trav_amount, ai.net_paid_contrib,
                      ai.payment_id, ai.returned, ai.recalc, ai.reissue,
                      ai.debt_returned, ai.prev_returned, ai.prev_reissue,
                      ai.payee_reference
                     )
              VALUES (temp_award_id, due_date_in, 'MN',
                      SYSDATE, amount_in, 0,
                      0, temp_net_amount, temp_payment_method, payee_type_in,
                      temp_payment_addr, NULL, 'U',
                      NULL, travel_element_in, NULL,
                      NULL, 'N', 'N', 'N',
                      'N', NULL, NULL,
                      UPPER (reference_in)
                     );                     

         SELECT sgas.award_instalment_id_seq.CURRVAL
           INTO temp_award_instalment_id
           FROM DUAL;

         ERROR_TEXT := 'Updating dsa allowance ';

         /*
          *    Update Allowance record to reflect new payment made
          */
         UPDATE dsa_allowance da
            SET da.paid_amount = da.paid_amount + (amount_in - travel_element_in),
                da.available_amount = da.available_amount - (amount_in - travel_element_in),
                da.last_updated_by = UPPER (employee_in),
                da.last_updated_on = SYSDATE
          WHERE da.ID = dsa_allowance_id_in;
      ELSE
         ERROR_TEXT := 'Updating dsa allowance ';

         /*
          *    Update Allowance record to reflect new payment received
          */
         UPDATE dsa_allowance da
            SET da.paid_amount = da.paid_amount + (amount_in - travel_element_in),
                da.available_amount = da.available_amount - (amount_in - travel_element_in),
                da.last_updated_by = UPPER (employee_in),
                da.last_updated_on = SYSDATE
          WHERE da.ID = dsa_allowance_id_in;
      END IF;

      ERROR_TEXT := 'Inserting DSA payment ';

      /*
       *    Insert DSA Payment record
       */
      INSERT INTO dsa_payment dp
                  (dp.award_instalment_id, dp.dsa_allowance_id,
                   dp.payee_id, dp.payment_method_id,
                   dp.dsa_payment_status_id, dp.amount, dp.amount_rate,
                   dp.batch_date, dp.invoice_ref, dp.notes,
                   dp.payee_type, dp.payment_type, dp.period_start_date,
                   dp.period_end_date, dp.process_date, dp.re_issue_flag,
                   dp.receipt_amount, dp.receipt_required,
                   dp.receipt_received, dp.REFERENCE,
                   dp.last_updated_by, dp.last_updated_on
                  )
           VALUES (temp_award_instalment_id, dsa_allowance_id_in,
                   payee_id_in, temp_dsa_payment_method,
                   1, temp_net_amount, amount_rate_in,
                   NULL, UPPER (invoice_ref_in), UPPER (notes_in),
                   payee_type_in, payment_type_in, period_start_date_in,
                   period_end_date_in, due_date_in, 'N',
                   receipt_amount_in, receipt_required_in,
                   receipt_received_in, UPPER (reference_in),
                   UPPER (employee_in), SYSDATE
                  );

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT :=
            ERROR_TEXT || 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;
   END processreceipt;

   PROCEDURE getstuddsaotherlimits (
      stud_award_type_scheme_in   IN              VARCHAR2,
      session_code_in             IN              VARCHAR2,
      disab_basic_max_out         OUT NOCOPY      VARCHAR2,
      disab_equip_max_out         OUT NOCOPY      VARCHAR2,
      disab_non_med_max_out       OUT NOCOPY      VARCHAR2,
      disab_trav_max_out          OUT NOCOPY      VARCHAR2,
      disab_accom_max_out         OUT NOCOPY      VARCHAR2,
      error_boolean               OUT NOCOPY      VARCHAR2,
      ERROR_TEXT                  OUT NOCOPY      VARCHAR2
   )
   IS
   BEGIN
      IF stud_award_type_scheme_in != 'NMSB'
      THEN
         SELECT a.disab_basic_max, a.disab_equip_max,
                a.disab_non_med_max, b.disab_trav_max,
                a.disab_accom_max
           INTO disab_basic_max_out, disab_equip_max_out,
                disab_non_med_max_out, disab_trav_max_out,
                disab_accom_max_out
           FROM (SELECT sr.disab_basic_max, sr.disab_equip_max,
                        sr.disab_non_med_max, sr.disab_accom_max
                   FROM stud_award_type sat, stud_rate sr
                  WHERE sat.stud_award_type_id = sr.stud_award_type_id
                    AND sat.scheme = stud_award_type_scheme_in
                    AND sr.session_code = session_code_in
                    AND sr.disab_trav_max = 0) a,
                (SELECT sr.disab_trav_max
                   FROM stud_award_type sat, stud_rate sr
                  WHERE sat.stud_award_type_id = sr.stud_award_type_id
                    AND sat.scheme = stud_award_type_scheme_in
                    AND sr.session_code = session_code_in
                    AND sr.disab_trav_max != 0) b;
      ELSE
         SELECT a.disab_basic_max, a.disab_equip_max,
                a.disab_non_med_max, 0,
                a.disab_accom_max
           INTO disab_basic_max_out, disab_equip_max_out,
                disab_non_med_max_out, disab_trav_max_out,
                disab_accom_max_out
           FROM (SELECT sr.disab_basic_max, sr.disab_equip_max,
                        sr.disab_non_med_max, sr.disab_accom_max
                   FROM stud_award_type sat, stud_rate sr
                  WHERE sat.stud_award_type_id = sr.stud_award_type_id
                    AND sat.scheme = stud_award_type_scheme_in
                    AND sr.session_code = session_code_in
                    AND sr.disab_trav_max = 0) a;
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getstuddsaotherlimits;

   PROCEDURE removeallocatednominee (
      stud_ref_no_in  IN       VARCHAR2,
      nom_id_in       IN       NUMBER,
      user_in         IN       VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
   BEGIN
      /*
       * REMOVE ALLOCATED NOMINEE DETAILS
       */
      UPDATE stud_nominee sn
         SET sn.last_updated_by = UPPER (user_in)
       WHERE sn.stud_ref_no = stud_ref_no_in  
         AND sn.nominee_id = nom_id_in;

      DELETE FROM stud_nominee sn
            WHERE sn.stud_ref_no = stud_ref_no_in
              AND sn.nominee_id = nom_id_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END removeallocatednominee;

   PROCEDURE getparttimedetails (
      stud_crse_year_id_in   IN       VARCHAR2,
      dsa_stud_type_id_out   OUT      VARCHAR2,
      part_time_course_out   OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
   BEGIN
   
      BEGIN 
          SELECT da.dsa_student_type_id, da.part_time_course
            INTO dsa_stud_type_id_out, part_time_course_out
            FROM dsa_application da, stud_crse_year scy, stud_session ss
           WHERE da.stud_ref_no = ss.stud_ref_no
             AND da.session_code = ss.session_code
             AND scy.stud_session_id = ss.stud_session_id
             AND scy.stud_crse_year_id = stud_crse_year_id_in;            
      EXCEPTION
          WHEN OTHERS
          THEN
               dsa_stud_type_id_out := ' ';
               part_time_course_out := ' ';
      END;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END getparttimedetails;

   PROCEDURE isneedsassessreportrequired (
      stud_crse_year_id_in   IN       VARCHAR2,
      is_required_out        OUT      VARCHAR2,
      error_boolean          OUT      VARCHAR2,
      ERROR_TEXT             OUT      VARCHAR2
   )
   IS
      temp_count_dsa_app   NUMBER;
   BEGIN
      SELECT COUNT (da.ID)
        INTO temp_count_dsa_app
        FROM dsa_application da, stud_crse_year scy, stud_session ss
       WHERE da.stud_ref_no = ss.stud_ref_no
         AND da.session_code = ss.session_code
         AND da.date_assess_rep_received IS NOT NULL
         AND scy.stud_session_id = ss.stud_session_id
         AND scy.stud_crse_year_id = stud_crse_year_id_in;

      IF temp_count_dsa_app < 1
      THEN
         is_required_out := 'true';
      ELSE
         is_required_out := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END isneedsassessreportrequired;

   PROCEDURE haspaymentbeenmade (
      id_in           IN       VARCHAR2,
      payment_made    OUT      VARCHAR2,
      error_boolean   OUT      VARCHAR2,
      ERROR_TEXT      OUT      VARCHAR2
   )
   IS
      paid_amount_value   NUMBER;
      payment_exists      NUMBER;
   BEGIN
      SELECT dsa.paid_amount
        INTO paid_amount_value
        FROM dsa_allowance dsa
       WHERE dsa.ID = id_in;

      SELECT COUNT (*)
        INTO payment_exists
        FROM dsa_payment dsp
       WHERE dsp.dsa_allowance_id = id_in;

      IF (paid_amount_value > 0 OR payment_exists > 0)
      THEN
         payment_made := 'true';
      ELSE
         payment_made := 'false';
      END IF;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
   EXCEPTION
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END haspaymentbeenmade;
   PROCEDURE updateallowancedetails (
      dsa_all_id_in                   IN      NUMBER,
      category_id_in                  IN      VARCHAR2,
      max_amt_in                      IN      NUMBER,
      user_in                         IN      VARCHAR2,
      nmph_hours_in                   IN      NUMBER,
      nmph_hourly_rate_in             IN      NUMBER,
      nmph_weeks_in                   IN      NUMBER,
      nmph_recommended_provider_in    IN      VARCHAR2,     
      travel_journeys_in              IN      NUMBER,
      travel_costs_in                 IN      NUMBER,
      travel_weeks_in                 IN      NUMBER,
      travel_recommended_provider_in  IN      VARCHAR2,
      travel_provider_id_in           IN      NUMBER,      
      travel_start_postcode_in        IN      VARCHAR2,      
      travel_end_postcode_in          IN      VARCHAR2,         
      nmph_type_of_support_in         IN      VARCHAR2,         
      pay_hei_in                      IN      VARCHAR2,        
      nmph_max_restricted_in          IN      VARCHAR2,  
      error_boolean                   OUT     VARCHAR2,
      ERROR_TEXT                      OUT     VARCHAR2,
      row_count_da                    OUT     VARCHAR2
   )
   IS 
        tmp_paid_amount number;
        tmp_available_amount number;
   BEGIN
   
      SELECT dsa.paid_amount
      INTO tmp_paid_amount 
      FROM dsa_allowance dsa
      WHERE Id = dsa_all_id_in;
      
      tmp_available_amount := max_amt_in - tmp_paid_amount;
   
      UPDATE dsa_allowance
         SET dsa_category_id = category_id_in,
             max_amount = max_amt_in,
             paid_amount = tmp_paid_amount,
             available_amount = tmp_available_amount,
             last_updated_by = UPPER (user_in),             
             nmph_hours = nmph_hours_in,
             nmph_hourly_rate = nmph_hourly_rate_in,
             nmph_weeks = nmph_weeks_in,
             nmph_recommended_provider = nmph_recommended_provider_in,
             travel_journeys = travel_journeys_in,
             travel_costs = travel_costs_in,
             travel_weeks = travel_weeks_in, 
             travel_recommended_provider = travel_recommended_provider_in,
             travel_provider_id = travel_provider_id_in,
             nmph_type_of_support = nmph_type_of_support_in,            
             last_updated_on = SYSDATE,
             start_postcode = travel_start_postcode_in,
             end_postcode = travel_end_postcode_in,
             pay_hei = pay_hei_in,
             nmph_max_restricted = nmph_max_restricted_in
       WHERE ID = dsa_all_id_in;

      row_count_da := SQL%ROWCOUNT;
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;   
   
   EXCEPTION 
      WHEN OTHERS
      THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;   
      ROLLBACK;   
   END updateallowancedetails;   
 PROCEDURE getdasallowancedetails (
      dsa_id_in               IN       NUMBER,
      available_amount_out    OUT      VARCHAR2,
      max_amount_out          OUT      VARCHAR2,
      paid_amount_out         OUT      VARCHAR2, 
      travel_amount_out       OUT      VARCHAR2,
      stud_session_id_out     OUT      VARCHAR2,
      stud_crse_year_id_out   OUT      VARCHAR2,  
      payment_due_date_out    OUT      VARCHAR2,
      date_paid_out           OUT      VARCHAR2,
      dsa_application_id_out  OUT      VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2                
   )
   IS
   BEGIN
   
    SELECT dsa.available_amount, dsa.max_amount, dsa.paid_amount, 
    dsa.travel_amount, dsa.stud_session_id, dsa.stud_crse_year_id,
    payment_due_date, date_paid, dsa_application_id 
    INTO available_amount_out, max_amount_out, paid_amount_out,
    travel_amount_out, stud_session_id_out, stud_crse_year_id_out,
    payment_due_date_out, date_paid_out, dsa_application_id_out  
    FROM  dsa_allowance dsa
    WHERE dsa.id = dsa_id_in;
   
    error_boolean := 'false';
    ERROR_TEXT := 'none';   
   
   EXCEPTION
     WHEN OTHERS
     THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;      
   END getdasallowancedetails; 
  PROCEDURE getPayment(
      dsp_id_in               IN       VARCHAR2,
      paid_amount_out         OUT      VARCHAR2,
      amount_out              OUT      VARCHAR2,
      reference_out           OUT      VARCHAR2, 
      travel_amount           OUT      VARCHAR2,
      invoice_ref             OUT      VARCHAR2, 
      due_date                OUT      VARCHAR2,
      receipt_amount          OUT      VARCHAR2, 
      receipt_required        OUT      VARCHAR2,      
      receipt_received        OUT      VARCHAR2,
      nominee_id              OUT      VARCHAR2,
      nominee_type            OUT      VARCHAR2,
      category_out            OUT      VARCHAR2,
      payment_status          OUT      VARCHAR2,
      allowance_id            OUT      VARCHAR2,      
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2             
  )
  IS
  BEGIN
  
    SELECT dsp.amount, dsp.reference, awi.trav_amount, dsp.invoice_ref,
    to_char(dsp.process_date, 'dd/MM/yyyy'), dsp.receipt_amount ,dsp.receipt_required, dsp.receipt_received,
    dsp.payee_id, dsp.payee_type, dsa.dsa_category_id, awi.payment_status, dsp.dsa_allowance_id,
    awi.amount   
    INTO  paid_amount_out, reference_out, travel_amount, invoice_ref,
    due_date, receipt_amount, receipt_required, receipt_received,
    nominee_id, nominee_type, category_out, payment_status, allowance_id,
    amount_out
    FROM dsa_payment dsp, dsa_allowance dsa, award_instalment awi
    WHERE dsa.id = DSP.DSA_ALLOWANCE_ID
    AND awi.award_instalment_id = dsp.award_instalment_id
    AND dsp.id = dsp_id_in;  
  
    error_boolean := 'false';
    ERROR_TEXT := 'none';     
  
  EXCEPTION
    WHEN OTHERS
     THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;     
  END getPayment;     
  PROCEDURE updatePayment(
      dsp_id_in               IN       VARCHAR2,
      amount_in               IN       VARCHAR2,
      reference_in            IN       VARCHAR2, 
      travel_amount_in        IN       VARCHAR2,
      invoice_ref_in          IN       VARCHAR2, 
      due_date                IN       VARCHAR2,
      receipt_amount_in       IN       VARCHAR2, 
      receipt_required_in     IN       VARCHAR2,      
      receipt_received_in     IN       VARCHAR2,
      user_in                 IN       VARCHAR2,
      error_boolean           OUT      VARCHAR2,
      ERROR_TEXT              OUT      VARCHAR2   
  )
  IS
      tmp_dsa_allowance_id        VARCHAR2(8);
      tmp_award_instalment_id     VARCHAR2(8);
      tmp_award_id                VARCHAR2(8);
      tmp_net_amount              VARCHAR2(8);
      tmp_paid_amount             VARCHAR2(8);
      tmp_amount                  VARCHAR2(8);
      tmp_new_paid_amount         VARCHAR2(8);
      tmp_max_amount              VARCHAR2(8);
      tmp_available_amount        VARCHAR2(8);
      tmp_travel_element          VARCHAR2(8);         
  BEGIN
        
    SELECT dsp.award_instalment_id, dsp.dsa_allowance_id, 
    awi.award_id, dsa.paid_amount, dsp.amount, dsa.max_amount 
    INTO tmp_award_instalment_id, tmp_dsa_allowance_id, 
    tmp_award_id, tmp_paid_amount, tmp_amount, tmp_max_amount  
    FROM dsa_payment dsp, dsa_allowance dsa, award_instalment awi
    WHERE dsa.id = DSP.DSA_ALLOWANCE_ID
    AND awi.award_instalment_id = dsp.award_instalment_id
    AND dsp.id = dsp_id_in;  
        
    ERROR_TEXT := 'Updating dsa payment'; 
    
    tmp_net_amount := amount_in - travel_amount_in; 
            
    UPDATE dsa_payment dsp
    SET dsp.amount = tmp_net_amount,
    dsp.process_date = to_date(due_date, 'dd/MM/yyyy'),
    dsp.reference = reference_in,
    dsp.receipt_required = receipt_required_in,
    dsp.receipt_received = receipt_received_in,
    dsp.receipt_amount = receipt_amount_in,
    dsp.invoice_ref = invoice_ref_in,
    dsp.last_updated_by = user_in,
    dsp.last_updated_on = SYSDATE
    WHERE dsp.id = dsp_id_in;

    tmp_new_paid_amount := (tmp_paid_amount - tmp_amount) + tmp_net_amount;    
    tmp_available_amount := tmp_max_amount - tmp_new_paid_amount;
    
    ERROR_TEXT := 'Updating dsa allowance';
    
    UPDATE dsa_allowance dsa
    SET dsa.paid_amount = tmp_new_paid_amount,
    dsa.available_amount = tmp_available_amount
    WHERE dsa.id = tmp_dsa_allowance_id;
    
    ERROR_TEXT := 'Updating award';
    
    UPDATE award aw
    SET aw.amount = amount_in,
    aw.net_amount = tmp_net_amount,
    aw.trav_amount = travel_amount_in,
    aw.assessment_date = SYSDATE,
    aw.last_updated_by = user_in, 
    aw.last_updated_on = SYSDATE
    WHERE aw.award_id = tmp_award_id;
    
    ERROR_TEXT := 'Updating award instalment';
    
    UPDATE award_instalment awi
    SET awi.payment_due_date = to_date(due_date, 'dd/MM/yyyy'),
    awi.assessment_date = SYSDATE,
    awi.amount = amount_in,
    awi.net_amount = tmp_net_amount,
    awi.trav_amount = travel_amount_in,
    awi.payee_reference = reference_in, 
    awi.last_updated_by = user_in,
    awi.last_updated_on = SYSDATE
    WHERE awi.award_instalment_id = tmp_award_instalment_id;    
        
    error_boolean := 'false';
    ERROR_TEXT := 'none' ;  
    COMMIT;       
  
  EXCEPTION
    WHEN OTHERS
     THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK; 
  END updatePayment;       
  PROCEDURE deletePayment(
       dsap_id_in             IN       VARCHAR2,
       user_in                IN       VARCHAR2,
       error_boolean          OUT      VARCHAR2,
       ERROR_TEXT             OUT      VARCHAR2        
  )  
  IS
    tmp_dsa_allowance_id           VARCHAR2(10);
    tmp_award_instalment_id        VARCHAR2(10);
    tmp_award_id                   VARCHAR2(10);
    tmp_dsap_amount                VARCHAR2(20);
    tmp_dsaa_paid_amount           VARCHAR2(20);
    tmp_dsaa_max_amount            VARCHAR2(20);    
    tmp_dsaa_available_amount      VARCHAR2(20);
    tmp_new_dsaa_paid_amount       VARCHAR2(20);
    tmp_new_dsaa_available_amount  VARCHAR2(20);            
  BEGIN
    
    -- Read award_instalment_id, award_id, amount 
    SELECT dsap.award_instalment_id, dsap.dsa_allowance_id, dsap.amount, awi.award_id
    INTO tmp_award_instalment_id, tmp_dsa_allowance_id, tmp_dsap_amount, tmp_award_id
    FROM dsa_payment dsap, award_instalment awi
    WHERE dsap.award_instalment_id = awi.award_instalment_id 
    AND dsap.id = dsap_id_in;
    
    -- Read paid_amount, max_amount  from dsa_allowance
    SELECT  dsaa.max_amount, dsaa.available_amount, dsaa.paid_amount
    INTO tmp_dsaa_max_amount, tmp_dsaa_available_amount, tmp_dsaa_paid_amount
    FROM dsa_allowance dsaa
    WHERE dsaa.id = tmp_dsa_allowance_id;
    
    -- subtract tmp_dsap_amount from tmp_dsaa_paid_amount
    tmp_new_dsaa_paid_amount := tmp_dsaa_paid_amount - tmp_dsap_amount; 
    
    -- subtract tmp_new_dsaa_paid_amount from tmp_dsaa_max_amount
    tmp_new_dsaa_available_amount := tmp_dsaa_max_amount - tmp_new_dsaa_paid_amount;
    
    -- Update dsa_allowance.paid_amount with tmp_new_dsaa_paid_amount and dsa_allowance.available_amount with tmp_new_dsaa_available_amount
    UPDATE dsa_allowance
    SET dsa_allowance.paid_amount = tmp_new_dsaa_paid_amount,
    dsa_allowance.available_amount = tmp_new_dsaa_available_amount,
    dsa_allowance.last_updated_by = user_in,
    dsa_allowance.last_updated_on = SYSDATE
    WHERE dsa_allowance.id = tmp_dsa_allowance_id;
    
    -- Delete records from award,award_instalment and dsa_payment tables
    DELETE FROM dsa_payment
    WHERE dsa_payment.id = dsap_id_in; 

    DELETE FROM award_instalment 
    WHERE award_instalment.award_instalment_id = tmp_award_instalment_id;

    DELETE FROM award
    WHERE award.award_id = tmp_award_id;
        
    
    error_boolean := 'false';
    ERROR_TEXT := 'none';
    COMMIT;    
    
  EXCEPTION
    WHEN OTHERS
     THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
         ROLLBACK;  
  END deletePayment;
  
  
      PROCEDURE getDSACorrespondenceTask(
       stud_ref_no            IN       VARCHAR2,
       noOfTasks              OUT      VARCHAR2,
       error_boolean          OUT      VARCHAR2,
       ERROR_TEXT             OUT      VARCHAR2         
  )
  IS
  BEGIN
  
  select count(TT.task_id) INTO noOfTasks
    from T_TASK_I_5C48842615@WMSTEPS.WORLD TT
    where (field_17 = 'DSACORRESPONDENCE')
        AND (field_1 = stud_ref_no)
        AND NOT (field_18 = 'Complete');
  
  EXCEPTION
    WHEN OTHERS
     THEN
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;     
  END getDSACorrespondenceTask;
  
  
PROCEDURE updateDsaAppStatus (      
      stud_ref_no_in        IN       NUMBER,
      session_code_in       IN       NUMBER,
      dsa_app_status_id_in  IN       NUMBER,      
      user_in               IN       VARCHAR2,
      error_boolean         OUT      VARCHAR2,
      ERROR_TEXT            OUT      VARCHAR2
   )
   IS
   BEGIN
      UPDATE dsa_application
         SET dsa_app_status = dsa_app_status_id_in,
             is_online = 'Y',
             last_updated_by=user_in,
             last_updated_on=SYSDATE
       WHERE stud_ref_no = stud_ref_no_in
         AND session_code = session_code_in;

      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;
   END updateDsaAppStatus;  
   
   
PROCEDURE getDSAAwardStatus (          
      stud_crse_yr_in           IN      NUMBER,
      publish_status_name       OUT     VARCHAR2,
      publish_status_descrip    OUT     VARCHAR2,
      award_status              OUT     VARCHAR2,
      hold_award                OUT     VARCHAR2,
      esa_total                 OUT     NUMBER,
      consumable_total          OUT     NUMBER,
      nmph_total                OUT     NUMBER,
      travel_total              OUT     NUMBER,
      accom_total               OUT     NUMBER,
      v_session_code            OUT     VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  )
  IS
  tmp_stud_ref_no            VARCHAR2(10);
  session_code           VARCHAR2(10);
  BEGIN
     
    select stud_ref_no, session_code
    into tmp_stud_ref_no,v_session_code
    from stud_crse_year 
    where stud_crse_year_id = stud_crse_yr_in;
  
    select NVL(hold_dsa_award_notice, 'N')
    into hold_award
    from stud_session
    where stud_ref_no = tmp_stud_ref_no
    and session_code = v_session_code;
    
    BEGIN
        select award_status, ps.status_name, ps.status_description
        into award_status, publish_status_name, publish_status_descrip
        from DSA_AWARD_PUBLISH_STATUS ps, dsa_award_notice an
        where an.publish_status = ps.dsa_publish_status_id
        and an.stud_ref_no IN (select stud_ref_no from stud_crse_year where stud_crse_year_id = stud_crse_yr_in)
        and an.session_code = v_session_code
        and an.current_record_ind = 'Y';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        select ps.status_name, ps.status_description
        into publish_status_name, publish_status_descrip
        from DSA_AWARD_PUBLISH_STATUS ps
        where ps.dsa_publish_status_id = 0;     
    END;
    
    BEGIN
        select sum(dai.product_value) 
        into esa_total
        from dsa_allowance da, dsa_allowance_item dai 
        where da.id = dai.dsa_allowance_id 
        and da.dsa_category_id IN 
            (select DC.DSA_CATEGORY_ID 
            from SGAS.DSA_CATEGORY dc 
            where DC.TYPE_ID = 1) 
        and dai.session_code = v_session_code 
        and da.stud_session_id IN (
            SELECT ss.stud_session_id
            FROM stud_session ss
            WHERE ss.stud_ref_no =
                (SELECT scy.stud_ref_no
                 FROM stud_crse_year scy
                 WHERE scy.stud_crse_year_id = stud_crse_yr_in));
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        esa_total := null;
    END;
    
    BEGIN
        select sum(da.max_amount)
        into consumable_total
        from dsa_allowance da
        where dsa_category_id IN
            (select DC.DSA_CATEGORY_ID 
            from SGAS.DSA_CATEGORY dc
            where DC.TYPE_ID = 2)
        and da.STUD_CRSE_YEAR_ID = stud_crse_yr_in; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        consumable_total := null;
    END;   
    
    BEGIN
        select sum(da.max_amount)
        into nmph_total
        from dsa_allowance da
        where dsa_category_id IN
            (select DC.DSA_CATEGORY_ID 
            from SGAS.DSA_CATEGORY dc
            where DC.TYPE_ID = 3
            and DSA_CATEGORY_ID != 36)
        and da.STUD_CRSE_YEAR_ID = stud_crse_yr_in;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        nmph_total := null;
    END;
    
    BEGIN
        select sum(da.max_amount)
        into travel_total
        from dsa_allowance da
        where dsa_category_id IN
            (select DC.DSA_CATEGORY_ID 
            from SGAS.DSA_CATEGORY dc
            where DC.TYPE_ID = 4)
        and da.STUD_CRSE_YEAR_ID = stud_crse_yr_in;   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        travel_total := null;
    END;
        
    BEGIN
        select sum(da.max_amount)
        into accom_total
        from dsa_allowance da
        where dsa_category_id IN
            (select DC.DSA_CATEGORY_ID 
            from SGAS.DSA_CATEGORY dc
            where DC.TYPE_ID = 5)
        and da.STUD_CRSE_YEAR_ID = stud_crse_yr_in;   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        travel_total := null;
    END;
      
      error_boolean := 'false';
      ERROR_TEXT := 'none';
      COMMIT;  
  EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;  
  END getDSAAwardStatus;
  
  PROCEDURE insertDSAAwardRecord (     
      stud_crse_yr_id_in        IN      NUMBER,
      user_in                   IN      VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  )
  IS
  tmp_dsa_application_id        VARCHAR2(10);
  tmp_stud_ref_no               NUMBER;
  tmp_session_code              NUMBER;
  BEGIN
  
      SELECT stud_ref_no, session_code
      INTO tmp_stud_ref_no, tmp_session_code
      FROM STUD_CRSE_YEAR
      WHERE stud_crse_year_id = stud_crse_yr_id_in;
  
      --update any previous records to say they're not current
      UPDATE dsa_award_notice
      SET current_record_ind = 'N'
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code;
      
      --get the app ID  
      SELECT ID
      INTO tmp_dsa_application_id
      FROM dsa_application
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code;
      
      --create a new row in the award notice table
      INSERT INTO dsa_award_notice 
        (dsa_application_id, 
        stud_ref_no, 
        session_code, 
        publish_status, 
        current_record_ind, 
        created_date, 
        last_updated_on, 
        last_updated_by)
      VALUES
        (tmp_dsa_application_id, 
        tmp_stud_ref_no, 
        tmp_session_code, 
        1, 
        'Y', 
        SYSDATE, 
        SYSDATE, 
        user_in);
  
  END insertDSAAwardRecord;
  
  
 PROCEDURE updateDSAAwardRecord (     
      stud_crse_yr_id_in        IN      NUMBER,
      user_in                   IN      VARCHAR2,
      award_status_in           IN      VARCHAR2,
      publish_status_in         IN      VARCHAR2,
      hold_award_in             IN      VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  )
  IS
  tmp_dsa_award_id              VARCHAR2(10);
  tmp_dsa_application_id        VARCHAR2(10); 
  tmp_stud_ref_no               NUMBER;
  tmp_session_code              NUMBER; 
  tmp_pay_hei                   NUMBER;
  tmp_nmph_max                  NUMBER;
  BEGIN
     
      SELECT stud_ref_no, session_code
      INTO tmp_stud_ref_no, tmp_session_code
      FROM STUD_CRSE_YEAR
      WHERE stud_crse_year_id = stud_crse_yr_id_in;
  
  --if hold award is Y then we only need to update that, otherwise updated everything
  
    IF (hold_award_in = 'Y') THEN
    
      UPDATE STUD_SESSION
      SET HOLD_DSA_AWARD_NOTICE = hold_award_in
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code;
      
    ELSE
    
      UPDATE STUD_SESSION
      SET HOLD_DSA_AWARD_NOTICE = hold_award_in
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code;
    
      SELECT ID
      INTO tmp_dsa_application_id
      FROM dsa_application
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code;
      
      SELECT DSA_AN_ID
      INTO tmp_dsa_award_id
      FROM dsa_award_notice
      WHERE stud_ref_no = tmp_stud_ref_no
      AND session_code = tmp_session_code
      AND current_record_ind = 'Y';     
  
      UPDATE dsa_award_notice
      SET 
        AWARD_STATUS = award_status_in,
        ESA_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'ESA' and DAT.IS_ACTIVE = 'Y'),
        ESA_AMT = (select sum(dai.product_value) from dsa_allowance da, dsa_allowance_item dai where da.id = dai.dsa_allowance_id and da.dsa_category_id IN (select DC.DSA_CATEGORY_ID from SGAS.DSA_CATEGORY dc where DC.TYPE_ID = 1) and dai.session_code = tmp_session_code AND da.stud_session_id IN (SELECT ss.stud_session_id FROM stud_session ss WHERE ss.stud_ref_no = (SELECT scy.stud_ref_no FROM stud_crse_year scy WHERE scy.stud_crse_year_id = stud_crse_yr_id_in))),
        CONSUMABLE_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'CONSUMABLES' and DAT.IS_ACTIVE = 'Y'),
        CONSUMABLE_AMT = (select sum(da.max_amount)from dsa_allowance da where dsa_category_id IN (select DC.DSA_CATEGORY_ID from SGAS.DSA_CATEGORY dc where DC.TYPE_ID = 2) and da.DSA_APPLICATION_ID = tmp_dsa_application_id),
        NMPH_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'NMPH' and DAT.IS_ACTIVE = 'Y'),
        NMPH_AMT = (select sum(da.max_amount)from dsa_allowance da where dsa_category_id IN (select DC.DSA_CATEGORY_ID from SGAS.DSA_CATEGORY dc where DC.TYPE_ID = 3 and DSA_CATEGORY_ID != 36) and da.DSA_APPLICATION_ID = tmp_dsa_application_id),
        TRAVEL_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'TRAVEL' and DAT.IS_ACTIVE = 'Y'),
        TRAVEL_AMT = (select sum(da.max_amount)from dsa_allowance da where dsa_category_id IN (select DC.DSA_CATEGORY_ID from SGAS.DSA_CATEGORY dc where DC.TYPE_ID = 4) and da.DSA_APPLICATION_ID = tmp_dsa_application_id),
        CRSE_CODE = (select crse_code from stud_crse_year where stud_ref_no = tmp_stud_ref_no and session_code = tmp_session_code and latest_crse_ind = 'Y'),
        INST_CODE = (select inst_code from stud_crse_year where stud_ref_no = tmp_stud_ref_no and session_code = tmp_session_code and latest_crse_ind = 'Y'),
        PUBLISH_STATUS = publish_status_in,
        LAST_UPDATED_ON = SYSDATE,
        LAST_UPDATED_BY = user_in,
        ACCOM_AMT = (select sum(da.max_amount)from dsa_allowance da where dsa_category_id IN (select DC.DSA_CATEGORY_ID from SGAS.DSA_CATEGORY dc where DC.TYPE_ID = 5) and da.DSA_APPLICATION_ID = tmp_dsa_application_id),
        ACCOM_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'ACCOM' and DAT.IS_ACTIVE = 'Y')
      WHERE dsa_an_id = tmp_dsa_award_id;
      
      --delete all existing records in secondary tables then add new rows
      
      DELETE FROM DSA_AWARD_NMPH_DATA
      WHERE DSA_AN_ID = tmp_dsa_award_id;
      
      DELETE FROM DSA_AWARD_TRAVEL_DATA
      WHERE DSA_AN_ID = tmp_dsa_award_id;
      
      DELETE FROM DSA_AWARD_ITEMISED_DATA
      WHERE DSA_AN_ID = tmp_dsa_award_id;
      
      DELETE FROM DSA_AWARD_ACCOM_DATA
      WHERE DSA_AN_ID = tmp_dsa_award_id;
      
      INSERT INTO DSA_AWARD_NMPH_DATA
        (DSA_AN_ID, 
        DSA_ALLOWANCE_ID, 
        TYPE_OF_SUPPORT,
        PROVIDER, 
        HOURLY_RATE, 
        HOURS, 
        WEEKS, 
        COST, 
        LAST_UPDATED_ON, 
        LAST_UPDATED_BY,
        MAX_RESTRICTED)
      select 
        tmp_dsa_award_id,
        da.id, 
        (CASE WHEN da.nmph_type_of_support is NULL then
            DC.description
            ELSE da.nmph_type_of_support
        END),
        da.nmph_recommended_provider, 
        da.nmph_hourly_rate, 
        da.nmph_hours, 
        da.nmph_weeks,
        da.max_amount,  
        SYSDATE, 
        user_in,
        da.nmph_max_restricted
      from DSA_ALLOWANCE da, DSA_CATEGORY dc
      where da.DSA_APPLICATION_ID = tmp_dsa_application_id
      AND  DC.TYPE_ID = 3
      AND DA.DSA_CATEGORY_ID != 36
      AND da.dsa_category_id = dc.dsa_category_id; --this ensures that assessment fee is not included
        
      INSERT INTO DSA_AWARD_TRAVEL_DATA
        (DSA_AN_ID, 
        DSA_ALLOWANCE_ID, 
        TRAVEL_JOURNEYS,
        TRAVEL_COSTS, 
        TRAVEL_WEEKS, 
        RECOMMENDED_PROVIDER, 
        TRAVEL_TYPE,
        START_POSTCODE,
        END_POSTCODE,
        MAX_AMOUNT,
        LAST_UPDATED_ON, 
        LAST_UPDATED_BY)
      select 
        tmp_dsa_award_id,
        da.id, 
        da.travel_journeys,
        da.travel_costs, 
        da.travel_weeks, 
        da.travel_recommended_provider, 
        dc.description,
        da.start_postcode,
        da.end_postcode,
        DA.MAX_AMOUNT,
        SYSDATE, 
        user_in
      from DSA_ALLOWANCE DA, DSA_CATEGORY DC
      where DSA_APPLICATION_ID = tmp_dsa_application_id
      AND DA.dsa_category_id = DC.DSA_CATEGORY_ID
      AND DC.TYPE_ID = 4;        
     
      INSERT INTO DSA_AWARD_ITEMISED_DATA
        (DSA_AN_ID, 
        DSA_ALLOWANCE_ID,
        DSA_ALLOWANCE_ITEM_ID, 
        DSA_CATEGORY,
        ITEM_TYPE,
        PRODUCT_NAME, 
        PRODUCT_DESCRIPTION, 
        PRODUCT_COST,
        LAST_UPDATED_ON, 
        LAST_UPDATED_BY)
      select 
        tmp_dsa_award_id,
        da.id,
        ai.dsa_allowance_item_id, 
        dc.type_id,
        ai.item_type,
        ai.product_name, 
        ai.product_description, 
        ai.product_value,
        SYSDATE, 
        user_in
      from DSA_ALLOWANCE DA, DSA_ALLOWANCE_ITEM AI, DSA_CATEGORY dc
      where DA.ID = AI.DSA_ALLOWANCE_ID
      AND DA.ITEMISED = 'Y'
      AND da.dsa_category_id = DC.DSA_CATEGORY_ID
      AND DC.TYPE_ID IN (1,2)
      AND ai.session_code = tmp_session_code
      AND da.stud_session_id IN (
        SELECT ss.stud_session_id
        FROM stud_session ss
        WHERE ss.stud_ref_no =
                  (SELECT scy.stud_ref_no
                   FROM stud_crse_year scy
                   WHERE scy.stud_crse_year_id = stud_crse_yr_id_in));
      
      SELECT COUNT (PAY_HEI)
      INTO tmp_pay_hei
      from DSA_ALLOWANCE DA, DSA_ALLOWANCE_ITEM AI, DSA_CATEGORY dc
      where DA.ID = AI.DSA_ALLOWANCE_ID
      AND DA.ITEMISED = 'Y'
      AND da.dsa_category_id = DC.DSA_CATEGORY_ID
      AND DC.TYPE_ID IN (1)
      AND da.stud_session_id IN (
        SELECT ss.stud_session_id
        FROM stud_session ss
        WHERE ss.stud_ref_no =
                  (SELECT scy.stud_ref_no
                   FROM stud_crse_year scy
                   WHERE scy.stud_crse_year_id = stud_crse_yr_id_in))
      AND da.pay_hei = 'Y';
      
      INSERT INTO DSA_AWARD_ACCOM_DATA
        (DSA_AN_ID, 
        DSA_ALLOWANCE_ID, 
        ACCOM_TYPE,
        ACCOM_STANDARD_COST,
        ACCOM_ENHANCED_COST, 
        ACCOM_WEEKS, 
        ACCOM_COST, 
        LAST_UPDATED_ON, 
        LAST_UPDATED_BY)
      select 
        tmp_dsa_award_id,
        da.id,  
        DC.DESCRIPTION,
        da.accom_standard_cost, 
        da.accom_enhanced_cost, 
        da.accom_weeks,
        da.max_amount,  
        SYSDATE, 
        user_in
      from DSA_ALLOWANCE da, DSA_CATEGORY dc
      where DSA_APPLICATION_ID = tmp_dsa_application_id
      AND da.dsa_category_id = DC.DSA_CATEGORY_ID
      AND dc.type_id = 5;
      
      IF tmp_pay_hei > 0
      THEN
      UPDATE dsa_award_notice
      SET 
        ESA_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'ESA_PAY_HEI' and DAT.IS_ACTIVE = 'Y')
      WHERE dsa_an_id = tmp_dsa_award_id;
      END IF;     
      
      SELECT COUNT (DA.NMPH_MAX_RESTRICTED)
      INTO tmp_nmph_max
      from DSA_ALLOWANCE DA
      where DSA_APPLICATION_ID = tmp_dsa_application_id
      and da.nmph_max_restricted = 'Y';
      
      IF tmp_nmph_max > 0
      THEN
      UPDATE dsa_award_notice
      SET 
        NMPH_TEXT = (select text_detail from DSA_AWARD_TEXT dat where DAT.TEXT_HEADING = 'LIMIT_NMPH_MAX' and DAT.IS_ACTIVE = 'Y')
      WHERE dsa_an_id = tmp_dsa_award_id;
      END IF;    
      
      /*IF publish_status_in = 2
      THEN
        UPDATE dsa_award_notice dan
        SET DAN.PUBLISH_STATUS = 3
        WHERE DAN.DSA_AN_ID = tmp_dsa_award_id;
      END IF;*/
      
    END IF;
        
  END updateDSAAwardRecord;
  
  PROCEDURE getDSAAwardValidationInfo(     
      stud_crse_yr_id_in        IN      NUMBER,
      changed_since_update_out  OUT     VARCHAR2,
      app_status_out            OUT     VARCHAR2,
      award_status_out          OUT     VARCHAR2,
      hold_dsa_award_out        OUT     VARCHAR2,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  )
  IS
  tmp_stud_ref_no               NUMBER;
  tmp_session_code              NUMBER; 
  tmp_award_notice_no           NUMBER;
  BEGIN
  
  SELECT scy.stud_ref_no, scy.session_code, SS.HOLD_DSA_AWARD_NOTICE
  INTO tmp_stud_ref_no, tmp_session_code, hold_dsa_award_out
  FROM STUD_CRSE_YEAR scy, stud_session ss
  WHERE scy.stud_crse_year_id = stud_crse_yr_id_in
  AND SS.STUD_REF_NO = SCY.STUD_REF_NO
  AND SS.SESSION_CODE = SCY.SESSION_CODE;  
  
  SELECT dsa_app_status
  INTO app_status_out
  FROM DSA_APPLICATION
  WHERE stud_ref_no = tmp_stud_ref_no
  AND session_code = tmp_session_code;
  
  --check if there are any award notice rows before comparing last updated on dates
  SELECT COUNT (*)
  INTO tmp_award_notice_no
  FROM DSA_AWARD_NOTICE dan
  WHERE DAN.CURRENT_RECORD_IND = 'Y'
  AND DAN.SESSION_CODE = tmp_session_code
  AND DAN.STUD_REF_NO = tmp_stud_ref_no;
  
  IF tmp_award_notice_no > 0
  THEN
    SELECT COUNT (*)
    INTO changed_since_update_out
    FROM DSA_AWARD_NOTICE dan
    WHERE DAN.CURRENT_RECORD_IND = 'Y'
    AND DAN.SESSION_CODE = tmp_session_code
    AND DAN.STUD_REF_NO = tmp_stud_ref_no
    AND DAN.LAST_UPDATED_ON < 
      (SELECT MAX (DA.LAST_UPDATED_ON)
      FROM DSA_ALLOWANCE DA
      WHERE DA.STUD_CRSE_YEAR_ID = stud_crse_yr_id_in);
      
    SELECT AWARD_STATUS
    INTO AWARD_STATUS_OUT
    FROM DSA_AWARD_NOTICE dan
    WHERE DAN.CURRENT_RECORD_IND = 'Y'
    AND DAN.SESSION_CODE = tmp_session_code
    AND DAN.STUD_REF_NO = tmp_stud_ref_no;
  ELSE
    changed_since_update_out := 1;
  END IF;
  
  END getDSAAwardValidationInfo;
  
  PROCEDURE deleteDSAAllowanceItem(     
      allowance_item_id_in      IN      NUMBER,
      allowance_id_in           IN      NUMBER,
      user_in                   IN      VARCHAR2,
      max_amount_out            OUT     NUMBER,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2
  )
  IS
  tmp_allowance_paid_amount     NUMBER;
  BEGIN
    
    SELECT paid_amount
    INTO tmp_allowance_paid_amount
    FROM dsa_allowance
    WHERE id = allowance_id_in;
    
    DELETE FROM DSA_ALLOWANCE_ITEM
    WHERE dsa_allowance_item_id = allowance_item_id_in;
    
    UPDATE dsa_allowance
    SET max_amount = NVL((select sum(dai.product_value)from dsa_allowance_item dai where dsa_allowance_id = allowance_id_in), 0),
    available_amount = ((select sum(dai.product_value)from dsa_allowance_item dai where dsa_allowance_id = allowance_id_in) - tmp_allowance_paid_amount),
    last_updated_on = SYSDATE,
    last_updated_by = user_in
    WHERE id = allowance_id_in;
    
    SELECT max_amount
    INTO max_amount_out
    FROM dsa_allowance
    WHERE id = allowance_id_in;
  
  END deleteDSAAllowanceItem;


  PROCEDURE getCourseEndDateByDsaAppId(
      dsa_app_id_in             IN      NUMBER,
      course_end_date           OUT     DATE,
      course_end_date_plus_six  OUT     DATE,
      error_boolean             OUT     VARCHAR2,
      ERROR_TEXT                OUT     VARCHAR2      
  )
  IS
    tmpStudCrseYear    NUMBER(9);
    tmpStudRefNo    NUMBER(10);
    tmpSessionCode    NUMBER(4);
  BEGIN
    --select SYSDATE INTO course_end_date from DUAL;  
        
    SELECT stud_ref_no, session_code
      INTO tmpStudRefNo, tmpSessionCode
      FROM dsa_application
     WHERE id = dsa_app_id_in;
     
    SELECT stud_crse_year_id
      INTO tmpStudCrseYear
      FROM stud_crse_year
     WHERE     stud_ref_no = tmpStudRefNo
           AND session_code = tmpSessionCode
           AND latest_crse_ind = 'Y';
        
    SELECT rules_proc_recalc.getStudyEnddate_2022 (tmpStudCrseYear)
      INTO course_end_date
      FROM DUAL;
      
    course_end_date_plus_six := ADD_MONTHS(course_end_date, 6);
        
  EXCEPTION
    WHEN OTHERS
     THEN
         course_end_date := NULL;
         error_boolean := 'true';
         ERROR_TEXT := 'SQLCODE=' || SQLCODE || ' SQL ERROR = ' || SQLERRM;     
  END getCourseEndDateByDsaAppId;        
  
END pk_steps_ui_dsa;
/
