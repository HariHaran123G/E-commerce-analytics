WITH BASE AS (
  SELECT d.delivery_partner, sum(oi.amount) as Tot_revenue, 
        COUNT(*) AS Tot_orders            
FROM deliveries d
JOIN order_items oi
ON oi.order_id=d.order_id
GROUP BY d.delivery_partner
),

Delayed AS( 
  SELECT d.delivery_partner, COUNT(*) AS Delayed_orders
FROM deliveries d
WHERE d.status='Delayed'
  GROUP BY d.delivery_partner  ),

COMBINED AS(
  SELECT b.*, del.Delayed_orders, del.Delayed_orders*100.0/b.Tot_orders AS Delay_pct
  FROM BASE b
  JOIN Delayed del
  ON del.delivery_partner=b.delivery_partner
  ),

Ranked AS(
    SELECT *,
Rank () OVER( ORDER BY Delay_pct ASC, Tot_revenue DESC) AS Rnk
  FROM COMBINED )
SELECT * FROM Ranked
WHERE Rnk = 1;
