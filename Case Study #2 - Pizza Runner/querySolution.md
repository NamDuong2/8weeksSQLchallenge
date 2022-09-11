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



