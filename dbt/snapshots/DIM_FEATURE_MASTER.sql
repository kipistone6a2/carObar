{% snapshot dim_feature_master %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='feature_id',
        strategy='check',
        check_cols=['feature_id,feature_name'],
    )
}}
select feature_id,feature_name from DEALERSHIPS.STAGE_CAROBAR.FEATURE_MASTER
{% endsnapshot %}
