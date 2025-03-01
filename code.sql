CREATE DATABASE Book_store;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


-- 1) Retrieve all books in the "Fiction" genre:
SELECT 
    *
FROM
    books
WHERE
    Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT 
    *
FROM
    books
WHERE
    Published_Year >= 1950;

-- 3) List all customers from the Canada:
SELECT 
    *
FROM
    customers
WHERE
    country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT 
    *
FROM
    orders
WHERE
    Order_Date LIKE '2023-11-%';

-- 5) Retrieve the total stock of books available:
SELECT 
    SUM(Stock) AS 'Total Stock'
FROM
    books;

-- 6) Find the details of the most expensive book:
SELECT 
    *
FROM
    books
ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT 
    *
FROM
    Orders
WHERE
    quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT 
    *
FROM
    project.orders
WHERE
    Total_Amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT
    Genre
FROM
    books;

-- 10) Find the book with the lowest stock:
SELECT 
    *
FROM
    books
ORDER BY stock
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:.
SELECT 
    SUM(Total_Amount) AS Revenue
FROM
    orders;

-- Advance Questions : 
-- 1) Retrieve the total number of books sold for each genre:
SELECT 
    books.Genre, SUM(orders.Quantity)
FROM
    orders
        JOIN
    books ON orders.Book_ID = books.Book_ID
GROUP BY books.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT 
    AVG(Price)
FROM
    books
WHERE
    Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT 
    orders.customer_id,
    customers.name,
    COUNT(orders.Order_id) AS ORDER_COUNT
FROM
    orders
        JOIN
    customers ON orders.customer_id = customers.customer_id
GROUP BY orders.customer_id
HAVING COUNT(Order_id) >= 2;

-- 4) Find the most frequently ordered book:
SELECT 
    orders.Book_id,
    books.title,
    COUNT(orders.order_id) AS ORDER_COUNT
FROM
    orders
        JOIN
    books ON orders.book_id = books.book_id
GROUP BY orders.book_id , books.title
ORDER BY ORDER_COUNT DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT 
    *
FROM
    books
WHERE
    Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT 
    books.Author, SUM(orders.Quantity) AS Quantity
FROM
    books
        JOIN
    orders ON books.Book_ID = orders.Book_ID
GROUP BY books.Author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT
    customers.city, total_amount
FROM
    orders
        JOIN
    customers ON orders.customer_id = customers.customer_id
WHERE
    orders.total_amount > 30;

-- 8) Find the customer who spent the most on orders:
SELECT 
    customers.customer_id, customers.name, SUM(orders.total_amount) AS Total_Spent
FROM
    orders
        JOIN
    customers  ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_id
ORDER BY Total_spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT books.book_id, books.title, books.stock, COALESCE(SUM(orders.quantity),0) AS Order_quantity,  
	books.stock- COALESCE(SUM(orders.quantity),0) AS Remaining_Quantity
FROM books 
LEFT JOIN orders ON books.book_id=orders.book_id
GROUP BY books.book_id ORDER BY books.book_id;
