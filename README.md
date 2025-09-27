# plsql-sql-windows-functions-MUNYAMBO-Alvin
Assignment using PL/SQL window functions
- BUSINESS CONTEXT 
 > My business is " MOVE RWANDA " , a ride company which is currently working here in RWANDA( kigali city, southern province, northern province, western province and eastern province). The MOVE compmany is seeking insights into driver perfomance in every region of the country and customer demand.
- DATA CHALLENGES
 > Although large amounts of trip data are collected, managers cannot easily identify top drivers, measure loyalty, or track demand report over time.
- EXPECTED OUTCOME
  > Identify top drivers per region/quarter
  > Track cumulative monthly revenue
  > Calculate month-over-month growth
  > Segment customers into loyalty quartiles
  > Forecast demand with moving averages
- SUCCESS CRITERIA
  > Top 5 drivers per city = RANK()
  > Running monthly revenue total = SUM() OVER()
  > Month over Month growth in rides = LAG()
  > Customer quartiles (loyalty segmentation) = NTILE(4)
  > 3 month moving averages of trips = AVG() OVER()
- DATABASE SCHEMA
 I used Oracle DBMS. The analysis utilizes a relational database with three primary tables:

 Table	      Purpose 	          Key columns
CUSTOMERS	    Customer info	      Customer_id(pk), Fname, Lname, city
DRIVERS	      Driver info	        Driver_id(pk), Fname, Lname, city
TRIPS	        Trip info	          Trip_id, customer_id(fk), driver_id(fk), date, amount.

- WINDOWS FUNCTIONS IMPLEMENTATION
  - 1. Ranking top 5 drivers per city = 
   > SELECT drivers.city,
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

  - 2. Aggreggrate, running total monthly revenue = 
  > SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
       SUM(trips.amount) AS monthly_revenue,
       SUM(SUM(trips.amount)) OVER (
           ORDER BY TO_CHAR(trips.trip_date, 'YYYY-MM')
       ) AS running_total
FROM trips
GROUP BY TO_CHAR(trips.trip_date, 'YYYY-MM')
ORDER BY month;

  - 3. Navigation, month over month growth =  
   > SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
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

  - 4. Distribution, customer quartiles(loyalty segmentation) = 
   > SELECT trips.customer_id,
       COUNT(trips.trip_id) AS trip_count,
       NTILE(4) OVER (ORDER BY COUNT(trips.trip_id) DESC) AS quartile
FROM trips
GROUP BY trips.customer_id
ORDER BY quartile, trip_count DESC;

  - 5. Moving average , 3 month rolling average of trips = 
   > SELECT TO_CHAR(trips.trip_date, 'YYYY-MM') AS month,
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

- INTERPRETATION (COMMENTS) OF ALL WINDOW FUNCTIONS
  
This set of queries analyzes trips, drivers, and customers over time. The ranking query shows which drivers earned the most revenue in each city and quarter, helping to identify top performers.

The aggregate and moving average queries calculate monthly revenue and a 3-month rolling average, making it easy to see trends and cumulative totals. The navigation query compares trips month-to-month, showing whether demand is increasing or decreasing.

Last but not least, the distribution query splits customers into quartiles based on activity, helping to understand which customers are the most or least active. Overall, these queries give a clear picture of performance, trends, and customer behavior.

-RESULTS INSIGHTS

- DESCRIPTIVE (What happened):
  1. Some drivers are very active; a few rarely take trips.
  2. A small group of customers take many trips, while new customer growth is slower.
  3. Most trips happen during weekdays and peak hours.
     
- DIAGNOSTIC (WHY?):
  1. Repeat customers stick with the service due to convenience.
  2. Commuting drives weekday trips; events and weekends cause occasional spikes.
  3. Driver activity differences may be due to location or engagement.
     
- PRESCRIPTIVE (What Next?):
  1. Reward active drivers and support less active ones to improve service.
  2. Schedule more drivers during peak hours.
  3. Encourage new customers with promotions and keep loyal ones happy.

- REFERENCES
  1. Freecodecamp ( https://www.freecodecamp.org/news/window-functions-in-sql/?utm_source=chatgpt.com )
  2. geeksforgeeks ( https://www.geeksforgeeks.org/sql/window-functions-in-sql/?utm_source=chatgpt.com )
  3. LearnSQL.com ( https://learnsql.com/blog/sql-window-functions-examples/?utm_source=chatgpt.com )
  4. MySql Documentation ( https://dev.mysql.com/doc/refman/8.1/en/window-functions-usage.html?utm_source=chatgpt.com )
  5. Mode Analytics ( https://mode.com/sql-tutorial/sql-window-functions/?utm_source=chatgpt.com )
  6. W3schools ( https://www.w3schools.com/sql/sql_window_functions.asp )
  7. Data school ( https://www.youtube.com/watch?v=8vTX2z3IOFQ )
  8. TechontheNet ( https://www.youtube.com/watch?v=Jh6Xv5l6Pp0 )
  9. Move Share by Volkswagen, Move Rwanda ( https://move.rw/?utm_source=chatgpt.com )
  10. Oracle corporation ( https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Window-Functions.html )

DONE!
  

     

