
--A-- Data Exploration : Display all data on the tables

SELECT * FROM PRODUCTION.BRANDS
SELECT * FROM PRODUCTION.CATEGORIES
SELECT * FROM PRODUCTION.PRODUCTS
SELECT * FROM PRODUCTION.STOCKS
SELECT * FROM sales.customers
SELECT * FROM sales.order_items
SELECT * FROM sales.orders
SELECT * FROM sales.staffs
SELECT * FROM sales.stores

--B-- Questions 

--1--Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
Select TOP 1 product_name, list_price 
From PRODUCTION.PRODUCTS
ORDER BY  list_price DESC;

--Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
select top 1 product_name, list_price
from production.products 
order by list_price desc

--The Motives could be the quality , the brand reputation , the bike materials and the technology used in it 

--2-- How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
Select Sum(customer_id) 'Customers'
From sales.customers

--

SELECT order_status ,COUNT(DISTINCT customer_id) 'customers'
FROM sales.orders
GROUP BY order_status;


-- These Customers with rejected orders are still considered as customers as they attempted to purchse and add orders 
--even if they didn't complete their tarnsactions they still have relationship with the store 

--3-- How many stores does BikeStore have?

Select Count(store_name) 'Total Stores'
From sales.stores

--4-- What is the total price spent per order?

Select order_id, Sum([list_price] *[quantity]*(1-discount)) AS 'Total Price'
FROM sales.order_items
GROUP BY order_id;



--5-- What’s the sales/revenue per store?
Select Store_id , Sum(list_price * quantity * (1 - discount)) AS 'Sales'
FROM sales.order_items
JOIN sales.orders ON sales.order_items.order_id = sales.orders.order_id
Group by Store_id;

--6-- Which category is most sold?

SELECT TOP 1 Category_name, sum(quantity) AS 'Most_Sold'
FROM sales.order_items
join production.products ON sales.order_items.product_id = production.products.product_id
join production.categories on production.categories.category_id=production.products.category_id
GROUP BY category_name
ORDER BY Most_Sold DESC;

--7-- Which category rejected more orders?
SELECT TOP 1 Category_name , COUNT(Order_status) AS 'Rejected_Orders'
FROM PRODUCTION.CATEGORIES
INNER JOIN PRODUCTION.PRODUCTS ON PRODUCTION.CATEGORIES.category_id = PRODUCTION.PRODUCTS.category_id 
INNER JOIN sales.order_items ON PRODUCTION.PRODUCTS.product_id = sales.order_items.product_id
INNER JOIN sales.orders ON sales.order_items.order_id = sales.orders.order_id
WHERE Order_status = 3
GROUP BY Category_name
ORDER BY Rejected_Orders desc;

--8-- hich bike is the least sold?

SELECT Top 1  product_name, sum(quantity) AS 'Total_Sold'
FROM sales.order_items
Join PRODUCTION.PRODUCTS ON sales.order_items.product_id =  PRODUCTION.PRODUCTS.product_id
GROUP BY product_name
ORDER BY Total_Sold ASC;


--9-- What’s the full name of a customer with ID 259?

SELECT first_name, last_name  
FROM sales.customers
where customer_id = 259;

--10-- What did the customer on question 9 buy and when? What’s the status of this order?

Select product_name, order_date, order_status
FROM sales.orders
JOIN sales.order_items ON sales.order_items.order_id = sales.orders.order_id
JOIN PRODUCTION.PRODUCTS ON PRODUCTION.PRODUCTS.product_id = sales.order_items.product_id
Where customer_id = 259;


--11-- Which staff processed the order of customer 259? And from which store?

SELECT STAFF.staff_id, STAFF.first_name + STAFF.last_name AS 'Full Name' ,  Stores.store_id, Stores.store_name
FROM sales.staffs Staff
JOIN sales.stores Stores ON Staff.store_id = Stores.store_id
JOIN sales.orders ON sales.orders.staff_id = Staff.staff_id
WHERE CUSTOMER_ID = 259;






--12-- How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?

SELECT COUNT(STAFF_ID) AS 'Total Staff'
FROM sales.staffs;

--Lead Staff

SELECT Staff_id, First_name + Last_name 'Full Name'
FROM sales.staffs
WHERE manager_id is Null;

--13-- Which brand is the most liked?

Select TOP 1 Brand_name , SUM(QUANTITY) 'Total_Quantity_SOLD'
From PRODUCTION.BRANDS B
Join PRODUCTION.PRODUCTS P ON B.brand_id = P.brand_id
Join sales.order_items s ON s.product_id = P.product_id
GROUP BY Brand_name
ORDER BY Total_Quantity_SOLD DESC;


--14-- How many categories does BikeStore have, and which one is the least liked?

SELECT COUNT(CATEGORY_ID) 'Total Categories'
FROM PRODUCTION.CATEGORIES

--least liked :

select TOP 1 c.Category_name , SUM(s.QUANTITY) 'Total_Quantity'
FROM PRODUCTION.CATEGORIES c
Join PRODUCTION.PRODUCTS p ON C.category_id = P.category_id
JOIN sales.order_items s ON p.product_id = s.product_id
group by Category_name
order by Total_Quantity asc;

--15-- Which store still have more products of the most liked brand?

select top 1 s.store_name,sum(st.quantity)  total_inventory
from production.stocks st
join production.products p 
on st.product_id = p.product_id
join sales.stores s 
on st.store_id = s.store_id
where p.brand_id = (
        select top 1 p.brand_id
        FROM sales.order_items oi
        join production.products p 
		on oi.product_id = p.product_id
        group by p.brand_id
        order by sum(oi.quantity) desc
    )
group by s.store_name
order by total_inventory desc;


--16-- Which state is doing better in terms of sales?

Select Top 1 state, SUM(list_price * quantity * (1 - discount)) AS Total_Sales
FROM sales.order_items
JOIN sales.orders ON sales.order_items.order_id = sales.orders.order_id
JOIN sales.stores ON sales.orders.store_id = sales.stores.store_id
GROUP BY state
ORDER BY total_sales DESC;


--17--  What’s the discounted price of product id 259?
Select  product_id,discount,  list_price * (1 - discount) AS discounted_price
FROM sales.order_items
where product_id  =259;


--18-- What’s the product name, quantity, price, category, model year and brand name of product number 44?

SELECT product_name, sum(quantity) 'Tota_Quantity', production.products.list_price, category_name, model_year, brand_name
FROM production.products
JOIN sales.order_items ON production.products.product_id = sales.order_items.product_id
JOIN production.categories ON production.products.category_id = production.categories.category_id
JOIN production.brands ON production.products.brand_id = production.brands.brand_id
WHERE production.products.product_id = 44
Group by product_name,  production.products.list_price, category_name, model_year, brand_name;

--19--  What’s the zip code of CA?Select  State, Zip_codeFROM sales.storesWhere State =  'CA';--20-- How many states does BikeStore operate in?SELECT Count(DISTINCT state) AS 'Number Of States'FROM sales.stores;--21--How many bikes under the children category were sold in the last 8 months?Select COUNT(Quantity) 'Total bikes sold'FROM sales.order_itemsJOIN SALES.ORDERS ON sales.order_items.ORDER_id = SALES.ORDERS.ORDER_idJOIN production.products ON sales.order_items.product_id = production.products.product_idWHERE CATEGORY_ID = ( SELECT category_id                      FROM production.categories                      WHERE category_name= 'Children' )AND order_date >= DATEADD(MONTH, -8, GETDATE());
--22-- What’s the shipped date for the order from customer 523?

SELECT SHIPPED_DATE , CUSTOMER_ID
FROM sales.orders
WHERE CUSTOMER_ID = 523;

--23-- How many orders are still pending?

SELECT count (order_id) 'Pending Orders'
FROM sales.orders
WHERE order_status = 1;

--24--  What’s the names of category and brand does "Electra white water 3i -2018" fall under?

SELECT C.CATEGORY_NAME , B.BRAND_NAME 
FROM PRODUCTION.PRODUCTS P
JOIN PRODUCTION.CATEGORIES C ON P.category_id = C.category_id
JOIN PRODUCTION.BRANDS B ON P.brand_id = B.brand_id 
where product_name='Electra white water 3i - 2018'




