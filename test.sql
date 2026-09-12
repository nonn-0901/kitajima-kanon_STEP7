--1
SELECT * FROM users;

--2
SELECT * FROM users WHERE '2024-01-01' <= created_at AND created_at <= '2024-12-31';

--3
SELECT * FROM users WHERE age < 30 AND gender = 'female';

--4
SELECT * FROM products;

--5
SELECT users.name, orders.order_date
FROM users JOIN orders
ON users.id = orders.user_id;

--6
SELECT products.product_name, products.price, order_items.quantity, 
    products.price * order_items.quantity AS total_price
FROM products JOIN order_items
ON products.id = order_items.product_id;

--7
SELECT users.name, COUNT(user_id)
FROM users JOIN orders
ON users.id = orders.user_id
GROUP BY users.name;

--8
SELECT users.name, SUM(products.price * order_items.quantity) AS total_price
FROM order_items
JOIN products
ON order_items.product_id = products.id
JOIN orders
ON order_items.order_id = orders.id
JOIN users
ON users.id = orders.user_id
GROUP BY users.name;

--9難しい
SELECT user_totals.name, user_totals.total_price
FROM (
    SELECT users.name, SUM(products.price * order_items.quantity) AS total_price
    FROM order_items
    JOIN products
    ON order_items.product_id = products.id
    JOIN orders
    ON order_items.order_id = orders.id
    JOIN users
    ON users.id = orders.user_id
    GROUP BY users.name
) AS user_totals
WHERE total_price = (SELECT MAX(total_price) FROM (
    SELECT users.name, SUM(products.price * order_items.quantity) AS total_price
    FROM order_items
    JOIN products
    ON order_items.product_id = products.id
    JOIN orders
    ON order_items.order_id = orders.id
    JOIN users
    ON users.id = orders.user_id
    GROUP BY users.name
)AS user_totals2);

--10
SELECT products.product_name, SUM(order_items.quantity)
FROM order_items JOIN products
ON order_items.product_id = products.id
GROUP BY products.product_name;

--11
SELECT users.name, COUNT(orders.user_id) AS count_order
FROM users LEFT JOIN orders
ON users.id = orders.user_id
GROUP BY users.name
HAVING count_order = 0;

--12
SELECT orders.id, COUNT(DISTINCT order_items.product_id) AS items_count
FROM orders JOIN order_items
ON orders.id = order_items.order_id
GROUP BY orders.id
HAVING items_count >= 2;

--13
SELECT users.name 
FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN users ON orders.user_id = users.id
WHERE order_items.product_id = 1;

SELECT users.name 
FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN users ON orders.user_id = users.id
JOIN products ON order_items.product_id = products.id
WHERE products.product_name = 'テレビ';

--14
SELECT order_items.id, orders.order_date, users.name, products.product_name, order_items.quantity,
products.price*order_items.quantity
FROM orders
JOIN users ON orders.user_id = users.id
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON products.id = order_items.product_id;

--15
SELECT products.product_name, SUM(order_items.quantity)
FROM products JOIN order_items
ON products.id = order_items.product_id
GROUP BY product_name
HAVING SUM(order_items.quantity) = 
    (SELECT MAX(sub.total_quantity) 
    FROM 
        (SELECT SUM(order_items.quantity) AS total_quantity
        FROM order_items
        GROUP BY product_id) AS sub
            );

--16
SELECT MONTH(orders.order_date), COUNT(orders.id)
FROM orders
GROUP BY MONTH(orders.order_date);

--17
SELECT products.product_name, COUNT(order_items.product_id) AS count_items
FROM products LEFT JOIN order_items
ON products.id = order_items.product_id
GROUP BY products.product_name
HAVING count_items = 0;

--18
CREATE INDEX idx_product ON order_items(product_id);

--19
SELECT AVG(sub.total_price) 
FROM
(SELECT SUM(products.price * order_items.quantity) AS total_price
FROM order_items
JOIN products
ON order_items.product_id = products.id
JOIN orders
ON order_items.order_id = orders.id
JOIN users
ON users.id = orders.user_id
GROUP BY users.name) AS sub;

--20難しい
SELECT users.name, orders.order_date
FROM users JOIN orders
ON users.id = orders.user_id
WHERE orders.order_date IN
(SELECT MAX(o.order_date)
FROM orders AS o
WHERE o.user_id = users.id);

--21
INSERT INTO users (id, name, age, gender, created_at) VALUES
(6, '中村愛', 25, 'female', '2025-06-01');

--22
INSERT INTO products (id, product_name, price) VALUES
(6, 'エアコン', 60000);

--23
INSERT INTO orders (id, user_id, order_date) VALUES
(10, 1, '2025-06-10');

--24
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
(10, 10, 6, 1);

--25
UPDATE users SET age = 24
WHERE users.name = '田中美咲';

--26
UPDATE products SET price = price*1.1;

--27
UPDATE orders SET order_date = '2024-05-01'
WHERE YEAR(orders.order_date) <= 2024 AND MONTH(orders.order_date) <5;

--28
DELETE FROM users
WHERE users.name = '高橋健一';

--29
DELETE FROM order_items
WHERE order_items.order_id = 5;

--30
DELETE FROM products
WHERE products.id NOT IN
(SELECT order_items.product_id FROM order_items);