/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Query #5: Which item was the most popular for each customer?
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

-- Query #6:  Which item was purchased first by the customer after they became a member?
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
