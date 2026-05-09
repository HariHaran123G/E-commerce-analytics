WITH A AS(
  SELECT d.delivery_partner, 
  SUM(CASE WHEN d.status= 'Delayed' THEN 1 ELSE 0 END) AS Delayed_orders,
  COUNT(*) AS Total_orders,
  AVG(delivery_time_mins) as Delivery_time
FROM deliveries d
GROUP BY d.delivery_partner),

B AS(SELECT *, Delayed_orders*100.0/Total_orders as Delayed_%
FROM A),

C AS(
  SELECT *, RANK() OVER(ORDER BY Delayed_% ASC, Delivery_time ASC) AS Rnk1
FROM B)

SELECT * FROM C
WHERE Rnk=1;
