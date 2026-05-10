WITH BASE AS(
  SELECT HOUR(o.order_date) AS Hourly_stamps, d.delivery_partner, 
        count(*) as Total_orders, 
        sum(oi.amount) as Tot_revenue
  FROM orders o
  JOIN deliveries d
  ON d.order_id=o.order_id
  JOIN order_items oi
  ON oi.order_id=o.order_id
  GROUP BY HOUR(o.order_date), d.delivery_partner),

Ranked AS(
  SELECT *, RANK() OVER( ORDER BY Total_orders DESC, Tot_revenue DESC) AS Rnk,      
  FROM BASE)

  SELECT * FROM Ranked
  WHERE Rnk=1;

--Query 2:
--Lunch vs dinner demand:
SELECT d.delivery_partner, 
  CASE
        WHEN HOUR(order_date) BETWEEN 13 AND 15
        THEN 'Lunch'     
        WHEN HOUR(order_date) BETWEEN 18 AND 23
        THEN 'Dinner'
        ELSE 'Other'
    END AS time_slot,
    COUNT(*) AS total_orders,
    SUM(oi.amount) AS total_revenue

FROM orders o
JOIN order_items oi
  ON oi.order_id = o.order_id
  JOIN deliveries d
  ON d.order_id=o.order_id

GROUP BY d.delivery_partner, time_slot;
