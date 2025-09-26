# plsql-sql-windows-functions-MUNYAMBO-Alvin
Assignment using PL/SQL window functions
- BUSINESS CONTEXT 
My business is " MOVE RWANDA " , a ride company which is currently working here in RWANDA( kigali city, southern province, northern province, western province and eastern province). The MOVE compmany is seeking insights into driver perfomance in every region of the country and customer demand.
- DATA CHALLENGES
Although large amounts of trip data are collected, managers cannot easily identify top drivers, measure loyalty, or track demand report over time.
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
