## Solution


### 5. Which item was the most popular for each customer?
````sql
WITH tb1 AS
(SELECT s.customer_id, s.product_id, 
        RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) desc) AS rank_p
FROM dannys_diner.sales s
GROUP BY s.customer_id,product_id)

SELECT tb1.customer_id, m.product_name
FROM tb1 
LEFT JOIN dannys_diner.menu m
ON tb1.product_id = m.product_id
WHERE tb1.rank_p = 1
ORDER BY tb1.customer_id
````
#### Answer:
| customer_id | product_name | 
| ----------- | ------------ |
| A           | ramen         |  
| B           | sushi        |  
| B           | curry        | 
| B           | ramen        | 
| C           | ramen        | 

### 6:  Which item was purchased first by the customer after they became a member?
````sql
WITH tb1 AS 
(SELECT s.customer_id, m.product_name, s.order_date, RANK() OVER(PARTITION BY s.customer_id ORDER BY (s.order_date - mem.join_date)) as ranking
 FROM dannys_diner.sales s
 INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
 INNER JOIN dannys_diner.members mem ON s.customer_id = mem.customer_id 
 WHERE (s.order_date - mem.join_date) >= 0)
 
SELECT tb1.customer_id, tb1.product_name
FROM tb1
GROUP BY tb1.customer_id, tb1.product_name, tb1.ranking
HAVING tb1.ranking = 1
````
#### Answer:
| customer_id | product_name | 
| ----------- | ------------ |
| A           | cury         |  
| B           | sushi        |  

### 7:  Which item was purchased just before the customer became a member?
````sql
WITH tb1 AS 
(SELECT s.customer_id, m.product_name, s.order_date, RANK() OVER(PARTITION BY s.customer_id ORDER BY (mem.join_date - s.order_date)) as ranking
 FROM dannys_diner.sales s
 INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
 INNER JOIN dannys_diner.members mem ON s.customer_id = mem.customer_id 
 WHERE (mem.join_date - s.order_date) > 0)
 
SELECT tb1.customer_id, tb1.product_name
FROM tb1
GROUP BY tb1.customer_id, tb1.product_name, tb1.ranking
HAVING tb1.ranking = 1
````

#### Answer:
| customer_id | product_name | 
| ----------- | ------------ |
| A           | cury         |  
| A           | sushi        |
| B           | sushi        |

### 8:  What is the total items and amount spent for each member before they became a member?
````sql
SELECT s.customer_id, COUNT(s.product_id) total_items, SUM(m.price) total_amount
FROM dannys_diner.sales s
INNER JOIN dannys_diner.members mem ON s.customer_id = mem.customer_id
INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
WHERE (mem.join_date - s.order_date) > 0
GROUP BY s.customer_id
ORDER BY s.customer_id
````
#### Answer:
| customer_id | total_items  | total_amount |
| ----------- | ------------ | ------------ |
| A           | 2            |  25          |
| B           | 3            |  40          |

#### Note: 
- total_items as I mean including duplicate items -> use COUNT(s.product_id)
- If it mean excluding duplicate items -> use COUNT(DISTINCT s.product_id)

### 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
````sql
SELECT s.customer_id, 
	   SUM(CASE WHEN s.product_id = 1
            THEN m.price*10*2
            ELSE m.price*10 END) total_point
FROM dannys_diner.sales s
INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
````
#### Answer:
| customer_id | total_point  | 
| ----------- | ------------ | 
| A           | 860          | 
| B           | 940          | 
| C           | 360          | 

### 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
````sql
SELECT s.customer_id, 
	   SUM(CASE WHEN (s.order_date - mem.join_date) >= 0 AND (s.order_date - mem.join_date) <= 6 THEN m.price*10*2
                WHEN s.product_id = 1 THEN m.price*10*2
           		ELSE m.price*10 END) total_point
FROM dannys_diner.sales s
INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
INNER JOIN dannys_diner.members mem ON s.customer_id = mem.customer_id
WHERE s.order_date <= to_date('20210131','YYYYMMDD')
GROUP BY s.customer_id
ORDER BY s.customer_id
````
#### Answer:
| customer_id | total_point  | 
| ----------- | ------------ | 
| A           | 1370         | 
| B           | 820          | 
