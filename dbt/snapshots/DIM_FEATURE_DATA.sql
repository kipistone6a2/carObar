{% snapshot dim_feature_data %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='feature_tracking',
        strategy='check',
        check_cols=['feature_tracking, ac_vent,alloy_wheel,automatic_climate_control,car_version_id,central_lock,child_lock_safety,colors,cruise_control,fog_lights,key_less_entry,parking_sensor,power_steering,rear_camera,sunroof'],
    )
}}
select feature_tracking, ac_vent,alloy_wheel,automatic_climate_control,car_version_id,central_lock,child_lock_safety,colors,cruise_control,fog_lights,key_less_entry,parking_sensor,power_steering,rear_camera,sunroof from DEALERSHIPS.STAGE_CAROBAR.FEATURE_DATA
{% endsnapshot %}
