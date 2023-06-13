{% snapshot click_data_fact %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_id',
        strategy='check',
        check_cols=['car_id,dealer_id,filters,timestamp'],
    )
}}
select car_id,dealer_id,filters,timestamp from DEALERSHIPS.STAGE_CAROBAR.CLICK_DATA
where dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
