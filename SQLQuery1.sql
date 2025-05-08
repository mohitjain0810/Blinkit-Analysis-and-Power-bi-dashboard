SELECT * FROM blinkit_data;

SELECT COUNT(*) FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data;

-- KPI REQUIREMENT

-- 1. Total Sales by Millions.
SELECT CONCAT(CAST(SUM(Sales)/1000000 AS DECIMAL(10, 2)), 'k') AS Total_Sales_Millions FROM blinkit_data;

-- 2. Average Sales.
SELECT CAST(AVG(Sales) AS DECIMAL(10, 0)) AS Avg_Sales FROM blinkit_data;
-- WE CAN USE ALSO ROUND(, 0)

-- 3. Number of items.
SELECT COUNT(*) AS No_of_Items FROM blinkit_data;

-- Total Sales of Low Fat only 
SELECT CAST(SUM(Sales)/1000000 AS DECIMAL(10, 2)) AS Total_Sales_Millions
FROM blinkit_data
WHERE Item_Fat_Content = 'Low Fat'; 

-- Total Sales of Outlet Establishmenet Year for 2022
SELECT CAST(SUM(Sales)/1000000 AS decimal(10, 2)) AS Total_Sales_Millions
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

-- Average Sales of Outlet Establishmment Year for 2022
SELECT CAST(AVG(Sales) AS decimal(10, 1)) AS Avg_Sales_Millions
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

-- How many number of item in outlet establishment year 2022
SELECT COUNT(*) AS No_of_Items FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;

-- 4. Average Rating
SELECT CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating FROM blinkit_data;


-- Granular Requirements

-- 1. Total Sales By Fat Content (Total, Sales, Average Sales, Number of items, Average Rating)
SELECT Item_Fat_Content,
                       CONCAT(CAST(SUM(Sales)/1000 As DECIMAL(10, 2)), 'k') As Total_sales_thousand,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
WHERE Outlet_Establishment_Year = 2020
Group By Item_Fat_Content
Order by Total_sales_thousand Desc;


-- 2. Total Sales by item Type
SELECT TOP 5 Item_Type,
                       CAST(SUM(Sales) As DECIMAL(10, 2)) As Total_sales,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
Group By Item_Type
Order by Total_sales ASC;

-- 3. Fat Content by Outlet for Total Sales.
SELECT Outlet_Location_Type, Item_Fat_Content,
                       CAST(SUM(Sales) As DECIMAL(10, 2)) As Total_sales,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
Group By Outlet_Location_Type, Item_Fat_Content
Order by Total_sales ASC;

-- In Pivot Table
SELECT Outlet_Location_Type,
       ISNULL([Low Fat], 0) AS Low_Fat,
	   ISNULL([Regular], 0) AS Regular
FROM 
(
  SELECT Outlet_Location_Type, Item_Fat_Content,
  CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales
  FROM blinkit_data
  GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT(
      SUM(Total_Sales) 
      FOR Item_Fat_Content IN([Low Fat], [Regular])
) As PivotTable
ORDER BY Outlet_Location_Type;

-- 4. Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year,
                       CAST(SUM(Sales) As DECIMAL(10, 2)) As Total_sales,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
Group By Outlet_Establishment_Year
Order by Outlet_Establishment_Year ASC;

-- Chart's Requirements

-- 1. Percentage of Sales by Outlet Size
SELECT 
      Outlet_Size,
	  CAST(SUM(Sales) AS Decimal(10, 2)) AS Total_sales,
	  CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage
From blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_sales DESC;


-- 2. Sales By Outlet Location
SELECT Outlet_Location_Type,
                       CAST(SUM(Sales) As DECIMAL(10, 2)) As Total_sales,
					   CAST((SUM(Sales) * 100.00/ SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
Group By Outlet_Location_Type
Order by Total_Sales DESC;


-- 3. All Metrics by Outlet Type
SELECT Outlet_Type,
                       CAST(SUM(Sales) As DECIMAL(10, 2)) As Total_sales,
					   CAST((SUM(Sales) * 100.00/ SUM(SUM(Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage,
					   CAST(AVG(Sales) As DECIMAL(10, 2)) As Average_sales,
					   COUNT(*) AS No_of_Items,
					   CAST(AVG(Rating) AS DECIMAL(10, 2)) AS Avg_Rating
From blinkit_data
Group By Outlet_Type
Order by Total_Sales DESC;