create or replace view DEALERSHIPS.MART_CAROBAR.VW_AGGREGATED_CAR_SALES_FACT(
	CAR_VERSION_ID,
	CAR_TYPE,
	CAR_ID,
	DEALER_ID,
	SUBDEALER_ID,
	ARRIVAL_DATE,
	SALE_DATE,
	SELL_PRICE,
	COST_PER_CAR,
	CITY,
	STATE,
	COUNT_BY_VERSION_TYPE,
	AVG_SELL_PRICE,
	AVG_COST,
	AVG_AGE,
	AVG_AGED_COST_PER_CAR,
	AVG_AGED_SELL_PRICE,
	"Stocked Minus Sold",
	STOCK_NEEDED,
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
	WIDTH
) as (
    SELECT
        sub.car_version_id,
        sub.car_type,
        cs.car_id,
        cs.dealer_id,
        cs.subdealer_id,
        cs.arrival_date,
        cs.sale_date,
        cs.sell_price,
        cs.cost_per_car,
        SPLIT_PART(cs.subdealer_id, '_', 2) AS CITY,
        split_part(cs.subdealer_id, '_', -1) AS STATE,
        sub.count_by_version_type,
        sub.avg_sell_price,
        sub.avg_cost,
        sub.avg_age,
        sub.avg_aged_cost_per_car,
        sub.avg_aged_sell_price,
        sub."Stocked Minus Sold",
        sub.stock_needed,
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
        gca.WIDTH
    FROM (
        SELECT
            cs1.car_version_id,
            cs1.car_type,
            COUNT(cs1.car_id) AS count_by_version_type,
            AVG(cs1.SELL_PRICE) AS avg_sell_price,
            AVG(cs1.cost_per_car) AS avg_cost,
            AVG(DATEDIFF('day', cs1.arrival_date, cs1.sale_date)) AS avg_age,
            CEIL(AVG(stock_metric)) AS "Stocked Minus Sold",
            CEIL(AVG(monthly_sold - monthly_stocked)) AS stock_needed,
            CEIL(AVG(cs3.avg_aged_cost_per_car)) AS avg_aged_cost_per_car,
            CEIL(AVG(cs3.avg_aged_sell_price)) AS avg_aged_sell_price
        FROM car_sales_fact cs1
        LEFT JOIN (
            SELECT
                sold.car_version_id,
                in_stock.car_type,
                in_stock.number_cars_stocked - sold.number_cars_sold AS stock_metric,
                in_stock.number_cars_stocked / 12 AS monthly_stocked,
                sold.number_cars_sold / 8 AS monthly_sold
            FROM (
                SELECT
                    car_version_id,
                    car_type,
                    COUNT(car_id) AS number_cars_sold
                FROM car_sales_fact
                WHERE sale_date > DATEADD(month, -1, CURRENT_DATE())
                GROUP BY car_version_id, car_type
            ) sold
            INNER JOIN (
                SELECT
                    car_version_id,
                    car_type,
                    COUNT(car_id) AS number_cars_stocked
                FROM car_sales_fact
                WHERE arrival_date > DATEADD(month, -2, CURRENT_DATE()) AND sale_date IS NULL
                GROUP BY car_version_id, car_type
            ) in_stock ON sold.car_version_id = in_stock.car_version_id AND sold.car_type = in_stock.car_type
        ) cs2 ON cs1.car_version_id = cs2.car_version_id AND cs1.car_type = cs2.car_type
        LEFT JOIN (
            SELECT
                car_version_id,
                car_type,
                AVG(sell_price) AS avg_aged_sell_price,
                AVG(cost_per_car) AS avg_aged_cost_per_car
            FROM car_sales_fact
            WHERE arrival_date > DATEADD(month, -2, CURRENT_DATE()) AND sale_date IS NULL
            GROUP BY car_version_id, car_type
        ) cs3 ON cs1.car_version_id = cs3.car_version_id AND cs1.car_type = cs3.car_type
        GROUP BY cs1.car_version_id, cs1.car_type
    ) sub
    JOIN dim_generic_car_attribute gca ON gca.car_version_id = sub.car_version_id
    JOIN dim_feature_data fd ON fd.car_version_id = sub.car_version_id
    JOIN car_sales_fact cs ON cs.car_version_id = sub.car_version_id
    ORDER BY sub.car_version_id
);