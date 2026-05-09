WITH BASE AS(
  SELECT o.city, SUM( case when d.status = 'Cancelled' then 1 else 0 END)
                  AS Cancelled_nos,
  COUNT(*) AS 'Total_orders'
  FROM deliveries d
  JOIN orders o
  ON o.order_id=d.order_id
  GROUP BY o.city
  )
SELECT *, Cancelled_nos*100.0/Total_orders as 'Cancellation_rate'
FROM BASE
