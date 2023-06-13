{% snapshot dim_employee %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='emp_id',
        strategy='check',
        check_cols=['emp_id,dealer_id,subdealer_id,department,emp_start_date,emp_end_date,emp_Fname,emp_lname,emp_phone,emp_city,emp_email,emp_commission'],
    )
}}
select emp_id,dealer_id,subdealer_id,department,emp_start_date,emp_end_date,emp_Fname,emp_lname,emp_phone,emp_city,emp_email,emp_commission from DEALERSHIPS.STAGE_CAROBAR.EMPLOYEE
where dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
