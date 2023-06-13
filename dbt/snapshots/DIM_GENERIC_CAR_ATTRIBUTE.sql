{% snapshot dim_generic_car_attribute %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_version_Id',
        strategy='check',
        check_cols=['audiosystem,body_type,brand,car_version_Id,child_safety_locks,city,city_mileage,displacement,doors,drivetrain,engine_location,front_brakes,fuel_gauge,fuel_lid_opener,fuel_system,fuel_tank_capacity,fuel_type,gears,ground_clearance,handbrake,height,highway_mileage,length,model,power,power_windows,rear_brakes,seating_capacity,seats_material,showroom_price,speedometer,state_code,tachometer,torque,variant,wheelbase,width'],
    )
}}
select audiosystem,body_type,brand,car_version_Id,child_safety_locks,city,city_mileage,displacement,doors,drivetrain,engine_location,front_brakes,fuel_gauge,fuel_lid_opener,fuel_system,fuel_tank_capacity,fuel_type,gears,ground_clearance,handbrake,height,highway_mileage,length,model,power,power_windows,rear_brakes,seating_capacity,seats_material,showroom_price,speedometer,state_code,tachometer,torque,variant,wheelbase,width from DEALERSHIPS.STAGE_CAROBAR.GENERIC_CAR_ATTRIBUTE
{% endsnapshot %}
