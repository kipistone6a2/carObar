{% snapshot customer_complaint_fact %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_version_id',
        strategy='check',
        check_cols=['customer_id, dealer_id, car_version_id, complaint'],
    )
}}
select customer_id, dealer_id, car_version_id, complaint from DEALERSHIPS.STAGE_CAROBAR.CUSTOMER_COMPLAINT
where dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
