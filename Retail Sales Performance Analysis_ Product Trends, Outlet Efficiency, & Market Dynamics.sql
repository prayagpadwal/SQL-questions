-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## Data Reading

-- COMMAND ----------

-- MAGIC %python
-- MAGIC df = spark.read.format('csv').option('inferSchema', True).option('header', True).load('/FileStore/tables/BigMart_Sales.csv')
-- MAGIC df.createOrReplaceTempView("BigMart_Sales")

-- COMMAND ----------

SELECT *
FROM BigMart_Sales
LIMIT 50;

-- COMMAND ----------

SELECT Item_MRP, Item_Outlet_Sales, CORR(Item_MRP, Item_Outlet_Sales) OVER (PARTITION BY ) AS Correlation
FROM bigmart_sales;

-- COMMAND ----------

--10. Can we identify any correlations between item MRP and outlet sales?
SELECT Item_Type, ROUND(AVG(Item_MRP), 0) AS Item_MRP, ROUND(AVG(Item_Outlet_Sales), 0) AS Item_Outlet_Sales, ROUND(MIN(Item_MRP), 0) AS Min_Item_MRP, ROUND(Max(Item_MRP), 0) AS Max_Item_MRP
FROM BigMart_Sales
GROUP BY Item_Type;

-- COMMAND ----------

--9. What is the price distribution of items within each item type category?
WITH CTE AS(
SELECT Item_Type, ROUND(MIN(Item_MRP), 0) AS Min_item_MRP, ROUND(MAX(Item_MRP),0) AS Max_item_MRP
FROM BigMart_Sales
GROUP BY Item_Type
)
SELECT Item_Type, Min_item_MRP, Max_item_MRP
FROM CTE;

-- COMMAND ----------

--8. What are the sales trends over the years? Has there been growth or decline in specific categories?
SELECT Outlet_Establishment_Year, ROUND(SUM(Item_Outlet_Sales), 0)
FROM BigMart_Sales
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- COMMAND ----------

--7. How do sales differ between outlets based on their size (Small, Medium, Large)?
SELECT Outlet_Size, ROUND(AVG(Item_Outlet_Sales), 0)
FROM BigMart_Sales
WHERE Outlet_Size IS NOT NULL
GROUP BY Outlet_Size;

-- COMMAND ----------

--6. Which outlet type generates the most sales per item?
SELECT Outlet_Type, ROUND(SUM(Item_Outlet_Sales), 2) AS Total_Sales
FROM BigMart_Sales
GROUP BY Outlet_Type
ORDER BY Outlet_Type DESC


-- COMMAND ----------

--5. What is the impact of item visibility on sales across different outlets?
SELECT ROUND(Avg(Item_Visibility), 4) AS Item_Visibility, Outlet_Identifier, ROUND(SUM(Item_Outlet_Sales), 0) AS Total_Sales
FROM BigMart_Sales
GROUP BY Outlet_Identifier
ORDER BY Item_Visibility DESC;

-- COMMAND ----------

--4. How do sales compare between low fat and regular items?
SELECT Item_Fat_Content AS Fat_type, SUM(Item_Outlet_Sales)
FROM BigMart_Sales
GROUP BY Fat_type;

-- COMMAND ----------

--3. What is the average item visibility of products in each product category?
SELECT ROUND(AVG(Item_Visibility),4) AS Avg_Visibility, Item_Type AS Product_Category
FROM BigMart_Sales
GROUP BY Product_Category

-- COMMAND ----------

--2.Which outlet has the highest overall sales?
SELECT Outlet_Identifier AS Outlet, ROUND(SUM(Item_Outlet_Sales), 0) AS Total_Sales
FROM BigMart_Sales
GROUP BY Outlet_Identifier
ORDER BY Total_Sales DESC
LIMIT 1;

-- COMMAND ----------

--1. What are the top 10 best-selling products?
SELECT Item_Type AS Products, ROUND(SUM(Item_Outlet_Sales), 0) AS Sales
FROM BigMart_Sales
GROUP BY Item_Type
ORDER BY Sales DESC
LIMIT 10;

-- COMMAND ----------


