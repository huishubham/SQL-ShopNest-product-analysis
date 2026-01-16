
/*===================================================================================================================================================================
ShopNest Website Analytics Project:
For ShopNest, a hypothetical e-commerce app, I used SQL Server to analyze user funnels, retention, conversion, and A/B test performance. I identified major 
drop-offs in the funnel, measured conversion by device, analyzed cohort retention, and validated that a simplified checkout flow improved conversion. 
Based on this, I recommended UX and checkout optimizations.
===================================================================================================================================================================*/


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 1.Understanding the User Base
---------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
COUNT(DISTINCT user_id) AS total_users
FROM users;

SELECT
city,
COUNT(DISTINCT user_id) AS total_users
FROM users
GROUP BY city
ORDER BY total_users DESC;


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 2.Funnel Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------

SELECT
    event_name,
    COUNT(DISTINCT user_id) AS users
FROM events
GROUP BY event_name
ORDER BY users DESC;

WITH funnel AS (
    SELECT user_id,
        MAX(CASE WHEN event_name = 'app_open' THEN 1 ELSE 0 END) AS app_open,
        MAX(CASE WHEN event_name = 'view_product' THEN 1 ELSE 0 END) AS view_product,
        MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
        MAX(CASE WHEN event_name = 'checkout' THEN 1 ELSE 0 END) AS checkout,
        MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase
    FROM events
    GROUP BY user_id
)
SELECT
    SUM(app_open) AS app_open,
    SUM(view_product) AS view_product,
    SUM(add_to_cart) AS add_to_cart,
    SUM(checkout) AS checkout,
    SUM(purchase) AS purchase
FROM funnel;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 3.Overall Conversion Rate
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    ROUND(COUNT(DISTINCT o.user_id) * 1.0 /
    COUNT(DISTINCT u.user_id),2) AS conversion_rate
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id;


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 4.Conversion Rate By Device
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    u.device,
    COUNT(DISTINCT o.user_id) * 1.0 /
    COUNT(DISTINCT u.user_id) AS conversion_rate
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.device;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 5.Retention Rate Day-1 and Day-7
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT e.user_id) * 1.0 /
    (SELECT COUNT(*) FROM users) AS day1_retention
FROM events e
JOIN users u
ON e.user_id = u.user_id
WHERE CAST(e.event_date AS DATE) = DATEADD(DAY, 1, u.signup_date);

SELECT
    COUNT(DISTINCT e.user_id) * 1.0 /
    (SELECT COUNT(*) FROM users) AS day7_retention
FROM events e
JOIN users u
ON e.user_id = u.user_id
WHERE CAST(e.event_date AS DATE) = DATEADD(DAY, 7, u.signup_date);


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 6.Cohort Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    DATENAME(MONTH, signup_date) AS cohort_month,
    COUNT(DISTINCT user_id) AS users
FROM users
GROUP BY DATENAME(MONTH, signup_date);

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 7.Revenue and ARPU Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    SUM(revenue) AS total_revenue
FROM orders;

SELECT
    SUM(o.revenue) * 1.0 / COUNT(DISTINCT u.user_id) AS ARPU
FROM users u
LEFT JOIN orders o
ON u.user_id = o.user_id;


---------------------------------------------------------------------------------------------------------------------------------------------------
-- 8.A/B Testing
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    variant,
    COUNT(DISTINCT user_id) AS users,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_id END) AS purchasers,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_id END) * 1.0 /
    COUNT(DISTINCT user_id) AS conversion_rate
FROM ab_events
GROUP BY variant;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 8.A/B Testing
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(DISTINCT user_id) FROM events WHERE event_name='app_open') AS app_opens,
    (SELECT COUNT(DISTINCT user_id) FROM orders) AS purchasers,
    (SELECT SUM(revenue) FROM orders) AS total_revenue;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9.KPI's
---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(DISTINCT user_id) FROM events WHERE event_name='app_open') AS app_opens,
    (SELECT COUNT(DISTINCT user_id) FROM orders) AS purchasers,
    (SELECT SUM(revenue) FROM orders) AS total_revenue;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9.Drop-off %
---------------------------------------------------------------------------------------------------------------------------------------------------
WITH funnel AS (
    SELECT user_id,
        MAX(CASE WHEN event_name='app_open' THEN 1 ELSE 0 END) app_open,
        MAX(CASE WHEN event_name='purchase' THEN 1 ELSE 0 END) purchase
    FROM events
    GROUP BY user_id
)
SELECT
1 - (SUM(purchase) * 1.0 / SUM(app_open)) AS overall_dropoff_rate
FROM funnel;
