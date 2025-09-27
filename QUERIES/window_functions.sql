WINDOW FUNCTION SQL 

1. RANK()

SELECT drivers.city,
       drivers.driver_id,
       SUM(trips.amount) AS total_revenue,
       RANK() OVER (
           PARTITION BY drivers.city, TO_CHAR(trips.trip_date, 'Q')
           ORDER BY SUM(trips.amount) DESC
       ) AS driver_rank
FROM trips
JOIN drivers ON trips.driver_id = drivers.driver_id
GROUP BY drivers.city, drivers.driver_id, TO_CHAR(trips.trip_date, 'Q')
ORDER BY drivers.city, driver_rank;

2. SUM(), OVER()

SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
       SUM(trips.amount) AS monthly_revenue,
       SUM(SUM(trips.amount)) OVER (
           ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')
       ) AS running_total
FROM trips
GROUP BY TO_CHAR(trips.trip_date, 'YYYY-MM')
ORDER BY month;

3. LAG()

SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
       COUNT(trips.trip_id) AS total_trips,
       LAG(COUNT(trips.trip_id)) OVER (
           ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')
       ) AS prev_month,
       ROUND(
         (COUNT(trips.trip_id) - LAG(COUNT(trips.trip_id)) OVER (ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')))
         / NULLIF(LAG(COUNT(trips.trip_id)) OVER (ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')), 0) * 100,
         2
       ) AS growth_percent
FROM trips
GROUP BY TO_CHAR(trips.trip_date, 'YYYY-MM')
ORDER BY month;

4. NTILE(4)

SELECT trips.customer_id,
       COUNT(trips.trip_id) AS trip_count,
       NTILE(4) OVER (ORDER BY COUNT(trips.trip_id) DESC) AS quartile
FROM trips
GROUP BY trips.customer_id
ORDER BY quartile, trip_count DESC;

5. AVG(), OVER()

SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
       COUNT(trips.trip_id) AS trips,
       ROUND(
         AVG(COUNT(trips.trip_id)) OVER (
           ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
         ), 2
       ) AS three_month_avg
FROM trips
GROUP BY TO_CHAR(trips.trip_date, 'YYYY-MM')
ORDER BY month;
