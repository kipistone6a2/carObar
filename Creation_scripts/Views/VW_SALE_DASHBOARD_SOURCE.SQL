create or replace view DEALERSHIPS.MART_CAROBAR.VW_SALE_DASHBOARD_SOURCE(
	DEALER_ID,
	SUBDEALER_ID,
	CAR_VERSION_ID,
	CAR_ID,
	CAR_TYPE,
	SELL_PRICE,
	COST_PER_CAR,
	SALE_DATE,
	ARRIVAL_DATE,
	CITY,
	STATE,
	AC_VENT,
	ALLOY_WHEEL,
	AUTOMATIC_CLIMATE_CONTROL,
	CENTRAL_LOCK,
	CHILD_LOCK_SAFETY,
	COLORS,
	CRUISE_CONTROL,
	FOG_LIGHTS,
	KEY_LESS_ENTRY,
	PARKING_SENSOR,
	POWER_STEERING,
	REAR_CAMERA,
	SUNROOF,
	AUDIOSYSTEM,
	BODY_TYPE,
	BRAND,
	CHILD_SAFETY_LOCKS,
	CITY_MILEAGE,
	DISPLACEMENT,
	DOORS,
	DRIVETRAIN,
	ENGINE_LOCATION,
	FRONT_BRAKES,
	FUEL_GAUGE,
	FUEL_LID_OPENER,
	FUEL_SYSTEM,
	FUEL_TANK_CAPACITY,
	FUEL_TYPE,
	GEARS,
	GROUND_CLEARANCE,
	HANDBRAKE,
	HEIGHT,
	HIGHWAY_MILEAGE,
	LENGTH,
	MODEL,
	POWER,
	POWER_WINDOWS,
	REAR_BRAKES,
	SEATING_CAPACITY,
	SEATS_MATERIAL,
	SHOWROOM_PRICE,
	SPEEDOMETER,
	STATE_CODE,
	TACHOMETER,
	TORQUE,
	VARIANT,
	WHEELBASE,
	WIDTH,
	USED_CAR_KILOMETERS,
	YEAR,
	EMP_ID,
	EMP_COMMISSION,
	EMP_LNAME,
	CUSTOMER_ID,
	CUSTOMER_AGE,
	AVG_AGED_SELL_PRICE,
	AVG_AGED_COST_PER_CAR,
	SALE_COUNT,
	TOTAL_CARS,
	AVG_SELL_PRICE,
	AVG_COST_PER_CAR,
	TOTAL_SELL_PRICE,
	TOTAL_COST_PER_CAR,
	AVG_USED_CAR_KILOMETERS,
	AVG_REMAINING_STOCK,
	STOCK_NEEDED,
	AVG_DAYS_SINCE_ARRIVAL,
	AVG_DAYS_UNTIL_SOLD,
	STOCK_METRIC,
	MONTHLY_STOCKED,
	MONTHLY_SOLD,
	AGE_RANGE,
	CUSTOMER_SEX,
	CUSTOMER_COUNT,
	TIME_SPENT_ON_LOT,
	STATUS,
	IS_SOLD,
	STOCK_DIFFERENCE,
	MONTHLY_SALES,
	MONTHLY_STOCKS
) as
WITH RankedSales AS (
    SELECT
        CASE
            WHEN c.customer_age BETWEEN 18 AND 25 THEN '18-25'
            WHEN c.customer_age BETWEEN 26 AND 35 THEN '26-35'
            WHEN c.customer_age BETWEEN 36 AND 45 THEN '36-45'
            WHEN c.customer_age BETWEEN 46 AND 55 THEN '46-55'
            WHEN c.customer_age BETWEEN 56 AND 65 THEN '56-65'
            WHEN c.customer_age BETWEEN 66 AND 75 THEN '66-75'
            WHEN c.customer_age BETWEEN 76 AND 85 THEN '76-85'
            WHEN c.customer_age BETWEEN 86 AND 95 THEN '86-95'
            WHEN c.customer_age > 95 THEN '96+'
            ELSE 'Unknown'
        END AS age_range,
        c.customer_sex,
        cs.car_version_id,
        COUNT(*) AS customer_count,
        ROW_NUMBER() OVER (PARTITION BY c.customer_sex,
            CASE
                WHEN c.customer_age BETWEEN 18 AND 25 THEN '18-25'
                WHEN c.customer_age BETWEEN 26 AND 35 THEN '26-35'
                WHEN c.customer_age BETWEEN 36 AND 45 THEN '36-45'
                WHEN c.customer_age BETWEEN 46 AND 55 THEN '46-55'
                WHEN c.customer_age BETWEEN 56 AND 65 THEN '56-65'
                WHEN c.customer_age BETWEEN 66 AND 75 THEN '66-75'
                WHEN c.customer_age BETWEEN 76 AND 85 THEN '76-85'
                WHEN c.customer_age BETWEEN 86 AND 95 THEN '86-95'
                WHEN c.customer_age > 95 THEN '96+'
                ELSE 'Unknown'
            END
            ORDER BY COUNT(*) DESC) AS rank
    FROM CUSTOMER_FACT c
    JOIN CAR_SALES_FACT cs ON c.customer_id = cs.customer_id
    GROUP BY age_range, c.customer_sex, cs.car_version_id
)
SELECT  
    cs.dealer_id,
    cs.subdealer_id,
    cs.car_version_id,
    cs.car_id,
    cs.car_type,  
    cs.sell_price, 
    cs.cost_per_car, 
    cs.sale_date, 
    cs.arrival_date,
    SPLIT_PART(cs.subdealer_id, '_', 2) AS CITY,
    split_part(cs.subdealer_id, '_', -1) AS STATE,
    fd.AC_VENT,
    fd.ALLOY_WHEEL,
    fd.AUTOMATIC_CLIMATE_CONTROL,
    fd.CENTRAL_LOCK,
    fd.CHILD_LOCK_SAFETY,
    fd.COLORS,
    fd.CRUISE_CONTROL,
    fd.FOG_LIGHTS,
    fd.KEY_LESS_ENTRY,
    fd.PARKING_SENSOR,
    fd.POWER_STEERING,
    fd.REAR_CAMERA,
    fd.SUNROOF,
    gca.AUDIOSYSTEM,
    gca.BODY_TYPE,
    gca.BRAND,
    gca.CHILD_SAFETY_LOCKS,
    gca.CITY_MILEAGE,
    gca.DISPLACEMENT,
    gca.DOORS,
    gca.DRIVETRAIN,
    gca.ENGINE_LOCATION,
    gca.FRONT_BRAKES,
    gca.FUEL_GAUGE,
    gca.FUEL_LID_OPENER,
    gca.FUEL_SYSTEM,
    gca.FUEL_TANK_CAPACITY,
    gca.FUEL_TYPE,
    gca.GEARS,
    gca.GROUND_CLEARANCE,
    gca.HANDBRAKE,
    gca.HEIGHT,
    gca.HIGHWAY_MILEAGE,
    gca.LENGTH,
    gca.MODEL,
    gca.POWER,
    gca.POWER_WINDOWS,
    gca.REAR_BRAKES,
    gca.SEATING_CAPACITY,
    gca.SEATS_MATERIAL,
    gca.SHOWROOM_PRICE,
    gca.SPEEDOMETER,
    gca.STATE_CODE,
    gca.TACHOMETER,
    gca.TORQUE,
    gca.VARIANT,
    gca.WHEELBASE,
    gca.WIDTH,
    dica.used_car_kilometers, 
    dica.year, 
    e.emp_id, 
    e.emp_commission, 
    e.emp_lname, 
    c.customer_id, 
    c.customer_age,
    cs3.avg_aged_sell_price,
    cs3.avg_aged_cost_per_car,
    cs2.sale_count,
    cs2.total_cars,
    cs2.avg_sell_price,
    cs2.avg_cost_per_car,
    cs2.total_sell_price,
    cs2.total_cost_per_car,
    cs2.avg_used_car_kilometers,
    cs2.avg_remaining_stock,
    cs2.stock_needed,
    cs4.avg_days_since_arrival,
    cs4.avg_days_until_sold,
    cs5.stock_metric,
    cs5.monthly_stocked,
    cs5.monthly_sold,
    rs.age_range,
    rs.customer_sex,
    rs.customer_count,
    ltsa.TIME_SPENT_ON_LOT,
    ltsa.STATUS,
    ltsa.IS_SOLD,
    ltsa.STOCK_DIFFERENCE,
    ltsa.MONTHLY_SALES,
    ltsa.MONTHLY_STOCKS
FROM car_sales_fact cs
JOIN dim_generic_car_attribute gca ON cs.car_version_id = gca.car_version_id
LEFT JOIN dim_individual_car_attributes dica ON cs.car_id = dica.car_id
LEFT JOIN dim_employee e ON cs.emp_id = e.emp_id
LEFT JOIN customer_fact c ON cs.customer_id = c.customer_id
LEFT JOIN dim_feature_data fd ON cs.car_version_id = fd.car_version_id
LEFT JOIN vw_LotTimeAndStockAmount ltsa on cs.car_id = ltsa.car_id
LEFT JOIN (
    SELECT
        sold.car_version_id,
        in_stock.number_cars_stocked - sold.number_cars_sold AS stock_metric,
         ceil(in_stock.number_cars_stocked / 2) AS monthly_stocked,
        sold.number_cars_sold AS monthly_sold
    FROM (
        SELECT
             cs.subdealer_id,
             dm.brand,
             dm.model,
             dm.variant,
             cs.car_version_id,
            COUNT(car_id) AS number_cars_sold
        FROM car_sales_fact cs JOIN dim_dealer_master dm on cs.car_version_id = dm.car_version_id
         WHERE sale_date > DATEADD(month, -1, '2023-03-01')
         GROUP BY cs.subdealer_id,cs.car_version_id,dm.brand,dm.model,dm.variant
    ) sold
    INNER JOIN (
         SELECT
            car_version_id,
             COUNT(car_id) AS number_cars_stocked
         FROM car_sales_fact
          WHERE arrival_date > DATEADD(month, -6, '2023-03-01') AND sale_date IS NULL
          GROUP BY car_version_id
     ) in_stock ON sold.car_version_id = in_stock.car_version_id
) cs5 ON cs.car_version_id = cs5.car_version_id
LEFT JOIN (
    SELECT
        car_version_id,
        AVG(sell_price) AS avg_aged_sell_price,
        AVG(cost_per_car) AS avg_aged_cost_per_car
    FROM car_sales_fact
    WHERE arrival_date > DATEADD(month, -6, '2023-03-01') AND sale_date IS NULL
    GROUP BY car_version_id
) cs3 ON cs.car_version_id = cs3.car_version_id
LEFT JOIN (
    SELECT         
        car_version_id,
        subdealer_id,
        CEIL(AVG(DATEDIFF('day', cs.arrival_date, '2023-03-01'))) AS avg_days_since_arrival,
        CEIL(AVG(DATEDIFF('day', cs.arrival_date, cs.sale_date))) AS avg_days_until_sold
    FROM car_sales_fact cs
    WHERE sale_date IS NOT NULL 
    GROUP BY car_version_id, subdealer_id
) cs4 ON cs.car_version_id = cs4.car_version_id
LEFT JOIN (
    SELECT
        cs.car_version_id,
        cs.subdealer_id,
        COUNT(cs.sale_date) AS sale_count,
        COUNT(cs.car_id) AS total_cars,
        CEIL(AVG(cs.SELL_PRICE)) AS avg_sell_price,
        CEIL(AVG(cs.COST_PER_CAR)) AS avg_cost_per_car,
        CEIL(SUM(cs.SELL_PRICE)) AS total_sell_price,
        CEIL(SUM(cs.COST_PER_CAR)) AS total_cost_per_car,
        CEIL(AVG(dica.used_car_kilometers)) AS avg_used_car_kilometers,
        CEIL(AVG(stock_metric)) AS avg_remaining_stock,
        CEIL(AVG(monthly_sold - monthly_stocked)) AS stock_needed
    FROM CAR_SALES_FACT cs
    LEFT JOIN dim_individual_car_attributes dica ON dica.car_id = cs.car_id
    LEFT JOIN (
    SELECT
        sold.car_version_id,
        in_stock.number_cars_stocked - sold.number_cars_sold AS stock_metric,
         in_stock.number_cars_stocked / 4 AS monthly_stocked,
        sold.number_cars_sold AS monthly_sold
    FROM (
        SELECT
             cs.subdealer_id,
             dm.brand,
             dm.model,
             dm.variant,
             cs.car_version_id,
            COUNT(car_id) AS number_cars_sold
        FROM car_sales_fact cs JOIN dim_dealer_master dm on cs.car_version_id = dm.car_version_id
         WHERE sale_date > DATEADD(month, -1, '2023-03-01')
         GROUP BY cs.subdealer_id,cs.car_version_id,dm.brand,dm.model,dm.variant
    ) sold
    INNER JOIN (
         SELECT
            car_version_id,
             COUNT(car_id) AS number_cars_stocked
         FROM car_sales_fact
          WHERE arrival_date > DATEADD(month, -6, '2023-03-01') AND sale_date IS NULL
          GROUP BY car_version_id
     ) in_stock ON sold.car_version_id = in_stock.car_version_id
) cs5 ON cs.car_version_id = cs5.car_version_id
    GROUP BY cs.car_version_id, cs.subdealer_id
) cs2 ON cs.car_version_id = cs2.car_version_id
LEFT JOIN RankedSales rs ON cs.car_version_id = rs.car_version_id
    AND c.customer_sex = rs.customer_sex
    AND rs.rank = 1
WHERE (cs.sale_date IS NULL OR cs.sale_date < '2023-03-01') AND cs.arrival_date < '2023-06-01'
ORDER BY age_range, c.customer_sex;