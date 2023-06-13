{% snapshot dim_manufacturer_master %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='manufacturer_tracking',
        strategy='check',
        check_cols=['dealer_id,manufacturer_tracking,manufacturer_id,manufacturer_name'],
    )
}}
select dealer_id,manufacturer_tracking,manufacturer_id,manufacturer_name from DEALERSHIPS.STAGE_CAROBAR.MANUFACTURER_MASTER
WHERE dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
