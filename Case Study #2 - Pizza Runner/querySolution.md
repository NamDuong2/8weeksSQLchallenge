# 🍕 Case Study #2 - Pizza Runner
## Pizza Metrics

### 1. How many pizzas were ordered?

````sql
SELECT COUNT(co.pizza_id) total_pizza
FROM pizza_runner.customer_orders co
````
**Answer:**
| total_pizza |
| ----------- |
| 14          |

### 2. How many unique customer orders were made? 
````sql
SELECT COUNT(DISTINCT co.order_id) unique_order_total
FROM pizza_runner.customer_orders co
````
**Answer:**
|unique_order_total|
| ---------------- |
| 10               |

### 3. How many successful orders were delivered by each runner?
````sql
SELECT ro.runner_id, COUNT(DISTINCT ro.order_id) successfull_order_total
FROM pizza_runner.runner_orders ro
WHERE ro.distance != 'null'
GROUP BY ro.runner_id;
````
**Answer:**
| runner_id | successfull_order_total |
| --------- | ----------------------- |
| 1         | 4                       |
| 2         | 3                       |
| 3         | 1                       |


### 4. How many of each type of pizza was delivered?
````sql
WITH successful_order AS (
   SELECT ro.order_id
   FROM pizza_runner.runner_orders ro
   WHERE ro.distance != 'null'
)
    
SELECT
  	co.order_id,
    co.pizza_id,
    COUNT(co.pizza_id) count_pizza
FROM pizza_runner.customer_orders co 
INNER JOIN  successful_order so
ON co.order_id = so.order_id 
GROUP BY co.order_id, co.pizza_id
ORDER BY co.order_id;
````
**Answer:**
| order_id | pizza_id | count_pizza |
| -------- | -------- | ----------- |
| 1        | 1        | 1           |
| 2        | 1        | 1           |
| 3        | 2        | 1           |
| 3        | 1        | 1           |
| 4        | 1        | 2           |
| 4        | 2        | 1           |
| 5        | 1        | 1           |
| 7        | 2        | 1           |
| 8        | 1        | 1           |
| 10       | 1        | 2           |
