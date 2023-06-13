{% snapshot dim_postpurchasesurvey %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_version_id',
        strategy='check',
        check_cols=['car_type,dealer_id,car_version_id,fuel_type,maintenance_costs,most_important_feature,ownership_experience,price_range,safety_features,seating_capacity,survey_tracking,transmission'],
    )
}}
select car_type,dealer_id,car_version_id,fuel_type,maintenance_costs,most_important_feature,ownership_experience,price_range,safety_features,seating_capacity,survey_tracking,transmission from DEALERSHIPS.STAGE_CAROBAR.POSTPURCHASESURVEY
WHERE dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
