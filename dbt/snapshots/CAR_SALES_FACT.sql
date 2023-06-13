{% snapshot car_sales_fact %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='car_id',
        strategy='check',
        check_cols=['customer_id, car_id, car_version_id, dealer_id, emp_id, manufacturer_id, arrival_date, car_type, sell_price, sale_date, cost_per_car, subdealer_id'],
    )
}}
select customer_id, car_id, car_version_id, dealer_id, emp_id, manufacturer_id, arrival_date, car_type, sell_price, sale_date, cost_per_car, subdealer_id from DEALERSHIPS.STAGE_CAROBAR.CAR_SALES
where dealer_id BETWEEN 4 AND 8
and arrival_date BETWEEN '2019-01-01' AND '2022-12-31'
{% endsnapshot %}
