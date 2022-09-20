# 🍕 Case Study #2 - Pizza Runner
## Pizza Metrics

### 1. How many pizzas were ordered?

````sql
SELECT COUNT(cot.pizza_id) total_pizza
FROM pizza_runner.customer_orders_transformed cot
````
**Answer:**
| total_pizza |
| ----------- |
| 14          |

### 2. How many unique customer orders were made? 
````sql
SELECT COUNT(DISTINCT cot.order_id) unique_order_total
FROM pizza_runner.customer_orders_transformed cot
````
**Answer:**
|unique_order_total|
| ---------------- |
| 10               |

### 3. How many successful orders were delivered by each runner?
````sql
SELECT rot.runner_id, COUNT(DISTINCT rot.order_id) successfull_order_total
FROM pizza_runner.runner_orders_transformed rot
WHERE rot.distance != ''
GROUP BY rot.runner_id;
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
   SELECT rot.order_id
   FROM pizza_runner.runner_orders_transformed rot
   WHERE rot.distance != ''
)
    
SELECT
    pn.pizza_name,
    COUNT(cot.pizza_id) count_pizza
FROM pizza_runner.customer_orders_transformed cot 
INNER JOIN  successful_order so
ON cot.order_id = so.order_id 
INNER JOIN pizza_runner.pizza_names pn
ON cot.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name
````
**Answer:**
| pizza_name| count_pizza | 
| --------- | ------------| 
| Meatlovers| 9           | 
| Vegetarian| 3           | 

### 5. How many Vegetarian and Meatlovers were ordered by each customer?
````sql
SELECT
    cot.customer_id,
    pn.pizza_name,
    COUNT(pn.pizza_name) count_pizza
FROM pizza_runner.customer_orders_transformed cot 
INNER JOIN  pizza_runner.pizza_names pn
ON cot.pizza_id = pn.pizza_id 
GROUP BY cot.customer_id, pn.pizza_name
ORDER BY cot.customer_id;
````
**Answer:**
| customer_id | pizza_name | count_pizza |
| ----------- | ---------- | ----------- |
| 101         | Meatlovers | 2           |
| 101         | Vegetarian | 1           |
| 102         | Meatlovers | 2           |
| 102         | Vegetarian | 1           |
| 103         | Meatlovers | 3           |
| 103         | Vegetarian | 1           |
| 104         | Meatlovers | 3           |
| 105         | Vegetarian | 1           |

### 6. What was the maximum number of pizzas delivered in a single order?
````sql
WITH pizza_per_order AS (
  SELECT
      rot.order_id,
      COUNT(cot.pizza_id) count_pizza
  FROM pizza_runner.runner_orders_transformed rot
  INNER JOIN pizza_runner.customer_orders_transformed cot
  ON rot.order_id = cot.order_id
  WHERE rot.distance != ''
  GROUP BY rot.order_id
)

SELECT MAX(count_pizza) max_pizza
FROM pizza_per_order
````
**Answer:**
| max_pizza |  
| --------- | 
| 3	    | 

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
````sql
SELECT cot.customer_id, 
	   SUM(CASE WHEN exclusions != '' OR extras != '' THEN 1
           ELSE 0 END) AS at_least_1_change,
       SUM(CASE WHEN exclusions = '' AND extras = '' THEN 1
           ELSE 0 END) AS no_change
FROM pizza_runner.runner_orders_transformed rot
LEFT JOIN pizza_runner.customer_orders_transformed cot
ON rot.order_id = cot.order_id
WHERE rot.distance != ''
GROUP BY cot.customer_id
ORDER BY cot.customer_id
````
**Answer:**
| customer_id | at_least_1_change | count_pizza |
| ----------- | ------------------| ----------- |
| 101         | 0                 | 2           |
| 102         | 0                 | 3           |
| 103         | 3                 | 0           |
| 104         | 2                 | 1           |
| 105         | 1                 | 0           |

### 8. How many pizzas were delivered that had both exclusions and extras?
````sql
SELECT  
	   SUM(CASE WHEN exclusions != '' AND extras != '' THEN 1
           ELSE 0 END) AS both_exclusions_extras
FROM runner_orders_transformed rot
LEFT JOIN customer_orders_transformed cot
ON rot.order_id = cot.order_id
WHERE rot.distance != ''
````
**Answer:**
| both_exclusions_extras |  
| ---------------------- | 
| 1	                   | 

### 9. What was the total volume of pizzas ordered for each hour of the day?
````sql
SELECT EXTRACT(HOUR from cot.order_time) hour_time,
	   COUNT(cot.pizza_id) volume
FROM customer_orders_transformed cot
GROUP BY EXTRACT(HOUR from cot.order_time)
ORDER BY EXTRACT(HOUR from cot.order_time)
````
**Answer:**
| hour_time   | volume |
| ----------- | -------| 
| 11          | 1      | 
| 13          | 3      | 
| 18          | 3      | 
| 19          | 1      | 
| 21          | 3      |
| 23          | 3      | 
### 10. What was the volume of orders for each day of the week?
````sql
SELECT to_char(cot.order_time, 'Day') day_of_week,
	   COUNT(DISTINCT cot.order_id) orders_volume
FROM customer_orders_transformed cot
GROUP BY to_char(cot.order_time, 'Day')
````
**Answer:**
| day_of_week | orders_volume |
| ----------- | --------------| 
| Friday      | 1      	      |  
| Saturday    | 2      	      | 
| Thursday    | 2      	      | 
| Wednesday   | 5             | 


