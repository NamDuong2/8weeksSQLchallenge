### TABLE: runner_orders
````sql
SELECT 
	order_id,
    runner_id,
	CASE WHEN pickup_time LIKE 'null' THEN ''
    ELSE pickup_time END AS pickup_time,
    CASE WHEN distance LIKE 'null' THEN ''
    WHEN distance LIKE '%km' THEN TRIM(TRAILING 'km' FROM distance)
    ELSE distance END AS distance,
    CASE WHEN duration LIKE 'null' THEN ''
    WHEN duration LIKE '%minute' THEN TRIM(TRAILING 'minute' FROM duration)
    WHEN duration LIKE '%minutes' THEN TRIM(TRAILING 'minutes' FROM duration)
    WHEN duration LIKE '%mins' THEN TRIM(TRAILING 'mins' FROM duration)
    ELSE duration END AS duration,
    CASE WHEN cancellation is NULL OR cancellation LIKE 'null' THEN ''
    ELSE cancellation END AS cancellation
INTO pizza_runner.runner_orders_transformed
FROM pizza_runner.runner_orders ro
````

| order_id | runner_id | pickup_time         | distance | duration | cancellation            |
| -------- | --------- | ------------------- | -------- | -------- | ----------------------- |
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                         |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                         |
| 3        | 1         | 2020-01-03 00:12:37 | 13.4     | 20       |                         |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                         |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                         |
| 6        | 3         |                     |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                         |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                         |
| 9        | 2         |                     |          |          | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                         |
