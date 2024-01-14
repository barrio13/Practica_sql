CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT calls.ivr_id,
      calls.phone_number,
      calls.ivr_result,
      calls.vdn_label,
      calls.start_date,
      FORMAT_DATETIME('%Y%m%d',calls.start_date) AS start_date_id,
      calls.end_date,
      FORMAT_DATETIME('%Y%m%d',calls.end_date) AS end_date_id,
      calls.total_duration,
      calls.customer_segment,
      calls.ivr_language,
      calls.steps_module,
      calls.module_aggregation,
      IFNULL(modules.module_sequece,-99999) AS module_sequece, 
      IFNULL(modules.module_name,'UNKNOWN') AS module_name,
      IFNULL(modules.module_duration,-99999) AS module_duration,
      IFNULL(modules.module_result,'UNKNOWN') AS module_result,
      IFNULL(steps.step_sequence,-99999) AS step_sequence,
      IFNULL(steps.step_name,'UKNOWN') AS step_name,
      IFNULL(steps.step_result,'UKNOWN') AS step_result,
      IFNULL(steps.step_description_error,'UKNOWN') AS step_description_error,
      IFNULL(steps.document_type,'UKNOWN') AS document_type,
      IFNULL(steps.document_identification,'UKNOWN') AS document_identification,
      IFNULL(steps.customer_phone,'UKNOWN') AS customer_phone,
      IFNULL(steps.billing_account_id,'UKNOWN') AS billing_account_id
 FROM `keepcoding.ivr_calls` calls
 LEFT JOIN `keepcoding.ivr_modules` modules
 ON calls.ivr_id = modules.ivr_id
 LEFT JOIN `keepcoding.ivr_steps` steps
 ON modules.ivr_id = steps.ivr_id AND modules.module_sequece = steps.module_sequece
 