{% snapshot dim_individual_car_attributes %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_version_Id',
        strategy='check',
        check_cols=['car_id,car_type,car_version_Id,subdealer_id,dealer_cost,dealer_id,sell_price,sold,used_Car_kilometers,used_vehicle_car_number,year'],
    )
}}
select car_id,car_type,car_version_Id,subdealer_id,dealer_cost,dealer_id,sell_price,sold,used_Car_kilometers,used_vehicle_car_number,year from DEALERSHIPS.STAGE_CAROBAR.INDIVDUAL_CAR_ATTRIBUTES
WHERE dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
