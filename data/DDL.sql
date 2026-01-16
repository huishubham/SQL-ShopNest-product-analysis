/* ===============================
   DROP TABLES IF EXIST
   =============================== */
IF OBJECT_ID('ab_events') IS NOT NULL DROP TABLE ab_events;
IF OBJECT_ID('orders') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('events') IS NOT NULL DROP TABLE events;
IF OBJECT_ID('users') IS NOT NULL DROP TABLE users;


/* ===============================
   CREATE TABLES
   =============================== */

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    signup_date DATE,
    device VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE events (
    event_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    event_date DATETIME,
    event_name VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATETIME,
    revenue DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE ab_events (
    ab_event_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    variant CHAR(1),
    event_name VARCHAR(50),
    event_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


/* ======================================
   2. USERS: 240 USERS ACROSS 4 MONTHS
   ====================================== */


/* ======================================
   2. USERS: 240 USERS ACROSS 4 MONTHS
   ====================================== */
DECLARE @i INT = 1;

WHILE @i <= 240
BEGIN
    INSERT INTO users (user_id, signup_date, device, city)
    VALUES (
        @i,
        DATEADD(
            DAY, @i % 28,
            DATEADD(MONTH, (@i - 1) / 60, '2025-01-01')
        ),
        CASE WHEN @i % 2 = 0 THEN 'mobile' ELSE 'desktop' END,
        CASE
            WHEN @i % 3 = 0 THEN 'Delhi'
            WHEN @i % 3 = 1 THEN 'Mumbai'
            ELSE 'Bangalore'
        END
    );

    SET @i = @i + 1;
END;


/* ======================================
   3. EVENTS + ORDERS (RETENTION + FUNNEL)
   ====================================== */
DECLARE @user INT = 1;

WHILE @user <= 240
BEGIN
    DECLARE @day INT = 0;

    WHILE @day <= 14
    BEGIN
        -- App Open (Day 0 always, returning users later)
        IF @day = 0 OR @user % 4 <> 0
            INSERT INTO events (user_id, event_date, event_name)
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                'app_open'
            FROM users WHERE user_id = @user;

        -- View Product
        IF @day <= 7 AND @user % 5 <> 0
            INSERT INTO events
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                'view_product'
            FROM users WHERE user_id = @user;

        -- Add to Cart
        IF @day <= 3 AND @user % 6 IN (1,2,3)
            INSERT INTO events
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                'add_to_cart'
            FROM users WHERE user_id = @user;

        -- Checkout
        IF @day <= 2 AND @user % 6 IN (1,2)
            INSERT INTO events
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                'checkout'
            FROM users WHERE user_id = @user;

        -- Purchase + Order
        IF @day <= 5 AND @user % 7 = 0
        BEGIN
            INSERT INTO events
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                'purchase'
            FROM users WHERE user_id = @user;

            INSERT INTO orders (user_id, order_date, revenue)
            SELECT
                @user,
                DATEADD(DAY, @day, signup_date),
                CASE
                    WHEN @user % 3 = 0 THEN 999
                    WHEN @user % 3 = 1 THEN 499
                    ELSE 799
                END
            FROM users WHERE user_id = @user;
        END

        SET @day = @day + 1;
    END

    SET @user = @user + 1;
END;


/* ======================================
   4. A/B TEST DATA
   ====================================== */

-- Experiment exposure
INSERT INTO ab_events (user_id, variant, event_name, event_date)
SELECT
    user_id,
    CASE WHEN user_id <= 120 THEN 'A' ELSE 'B' END,
    'experiment_exposed',
    signup_date
FROM users;

-- Higher conversion for Variant B
INSERT INTO ab_events
SELECT
    user_id,
    'B',
    'purchase',
    DATEADD(DAY, 3, signup_date)
FROM users
WHERE user_id > 120
  AND user_id % 4 = 0;
