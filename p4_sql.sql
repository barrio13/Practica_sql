CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH vdn_gen AS (
  SELECT ivr_id,
         vdn_label,
    CASE
      WHEN vdn_label LIKE 'ATC%' THEN 'FRONT'
      WHEN vdn_label LIKE 'TECH%' THEN 'TECH'
      WHEN vdn_label LIKE 'ABSORPTION' THEN 'ABSORPTION'
      ELSE 'RESTO'
    END AS vdn_aggregation
  FROM `keepcoding.ivr_detail`
)
,phone_recall AS(
  SELECT ivr_id,
       end_date,
       LEAD(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id) AS next_phone_call,
       DATETIME_DIFF(LEAD(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id),end_date,HOUR) AS hours_diff,
       IF(DATETIME_DIFF(LEAD(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id),end_date,HOUR) < 24,1,0) AS cause_recall_phone24H
FROM `keepcoding.ivr_calls` 
)
,rep_phone AS(
SELECT ivr_id,
       end_date,
       LAG(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id) AS previous_phone_call,
       DATETIME_DIFF(end_date,Lag(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id),HOUR) AS hours_diff,
       IF(DATETIME_DIFF(end_date,Lag(end_date) OVER(PARTITION BY phone_number ORDER BY end_date,ivr_id),HOUR) < 24,1,0) AS repeated_phone24H
FROM `keepcoding.ivr_calls` 
)
,cust_phone AS(
  SELECT ivr_id,
         customer_phone
FROM (
    SELECT
        ivr_id,
        customer_phone,
        ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY customer_phone) AS row_num
    FROM `keepcoding.ivr_detail`
)
WHERE row_num = 1
)
,bill_acc AS(
  SELECT ivr_id,
         billing_account_id
FROM (
    SELECT
        ivr_id,
        billing_account_id,
        ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY billing_account_id) AS row_num
    FROM `keepcoding.ivr_detail`
)
WHERE row_num = 1
)
,doc_info AS(
  SELECT ivr_id,
         document_type,
         document_identification
FROM(
 SELECT ivr_id,
         document_type,
         document_identification,
         ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY document_type,document_identification) AS row_num
FROM `keepcoding.ivr_detail`
)
WHERE row_num=1
)

SELECT
  detail.ivr_id,
  detail.phone_number,
  detail.ivr_result,
  detail.start_date,
  detail.end_date,
  detail.total_duration,
  detail.customer_segment,
  detail.ivr_language,
  detail.steps_module,
  detail.module_aggregation,
  vdn_gen.vdn_aggregation,
  MAX(IF(detail.module_name = 'AVERIA_MASIVA',1,0)) as masiva_lg,
  MAX(IF(detail.step_name='CUSTOMERINFOBYPHONE.TX' AND detail.step_description_error='UNKNOWN',1,0)) as info_by_phone_lg,
  MAX(IF(detail.step_name='CUSTOMERINFOBYDNI.TX' AND detail.step_description_error='UNKNOWN',1,0)) as info_by_dni_lg,
  phone_recall.cause_recall_phone24H,
  rep_phone.repeated_phone24H,
  IFNULL(cust_phone.customer_phone,'UNKNOWN') AS customer_phone,
  IFNULL(bill_acc.billing_account_id,'UNKNOWN') AS billing_account_id,
  IFNULL(doc_info.document_type,'UNKNOWN') AS document_type,
  IFNULL(doc_info.document_identification,'UNKNOWN') AS document_identification
FROM
  `keepcoding.ivr_detail` detail
LEFT JOIN
  vdn_gen
ON
  detail.ivr_id = vdn_gen.ivr_id
LEFT JOIN
  phone_recall
ON
  detail.ivr_id = phone_recall.ivr_id
LEFT JOIN
  rep_phone
ON
  detail.ivr_id = rep_phone.ivr_id
LEFT JOIN
 cust_phone
ON
 detail.ivr_id = cust_phone.ivr_id
LEFT JOIN
 bill_acc
ON
 detail.ivr_id = bill_acc.ivr_id
LEFT JOIN
 doc_info
ON
 detail.ivr_id = doc_info.ivr_id
GROUP BY
  ivr_id,
  phone_number,
  ivr_result,
  start_date,
  end_date,
  total_duration,
  customer_segment,
  ivr_language,
  steps_module,
  module_aggregation,
  vdn_aggregation,
  cause_recall_phone24H,
  repeated_phone24H,
  customer_phone,
  billing_account_id,
  document_type,
  document_identification