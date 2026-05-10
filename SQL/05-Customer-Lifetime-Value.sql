WITH Base AS(
  SELECT o.customer_id, SUM(oi.amount) AS Tot_revenue,
        COUNT(DISTINCT o.order_id) as Tot_orders, 
        COUNT(DISTINCT DATEFORMAT(order_date, '%Y-%m')) as Months
FROM orders o
JOIN order_items oi
ON oi.order_id=o.order_id
GROUP BY o.customer_id
),

--Valuing Loyalty over revenue 
Ranked AS(
  SELECT *, RANK() OVER( ORDER BY Months DESC , Tot_orders DESC, Tot_revenue DESC) as Rnk
FROM Base)

SELECT * FROM Ranked 
WHERE Rnk=1;  
