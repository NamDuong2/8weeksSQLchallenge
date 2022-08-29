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