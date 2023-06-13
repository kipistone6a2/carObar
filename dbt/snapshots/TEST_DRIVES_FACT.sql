{% snapshot test_drives_fact %}
{{
    config(
        target_database='dealerships',
        target_schema='mart_carobar',
        unique_key='test_drive_id',
        strategy='check',
        check_cols=['test_drive_id, car_version_id, dealer_id, emp_id, subdealer_id, test_drive_book_date, quote_released'],
    )
}}
select test_drive_id, car_version_id, dealer_id, emp_id, subdealer_id, test_drive_book_date, quote_released from DEALERSHIPS.STAGE_CAROBAR.TEST_DRIVES
WHERE dealer_id BETWEEN 4 AND 8
{% endsnapshot %}
