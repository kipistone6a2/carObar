{% snapshot customer_fact %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='customer_id',
        strategy='check',
        check_cols=['customer_id, dealer_id, subdealer_id, customer_age, customer_sex, fname, lname, bought_car, customer_email'],
    )
}}
select customer_id, dealer_id, subdealer_id, customer_age, customer_sex, fname, lname, bought_car, customer_email from DEALERSHIPS.STAGE_CAROBAR.CUSTOMER
where dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
