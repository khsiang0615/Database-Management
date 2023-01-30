USE BUDT703_Project_0501_06

--View data in all the tables
SELECT * FROM [Hotspots.Customer]
SELECT * FROM [Hotspots.Restaurant]
SELECT * FROM [Hotspots.Source]
SELECT * FROM [Hotspots.OperationTime]
SELECT * FROM [Hotspots.RestaurantCategory]
SELECT * FROM [Hotspots.Review]

DROP VIEW IF EXISTS NumOfCustomerPostedReview_V
DROP VIEW IF EXISTS NumOfRestaurantbyPriceLevel_V
DROP VIEW IF EXISTS TopRestaurantBasedOnPrice_V
DROP VIEW IF EXISTS Top_3_Restaurants_V
DROP VIEW IF EXISTS LongestOperatingRestaurants_V

--Q1. Which city has the most number of customers that posted a review?
GO
CREATE VIEW NumOfCustomerPostedReview_V
AS 
	SELECT TOP(1) c.cusCity AS 'City Name', c.cusState AS 'State Name', COUNT(r.rvwId) AS 'Number of Customers that Posted a Review'	
	FROM [Hotspots.Review] r, [Hotspots.Customer] c
	WHERE r.cusId = c.cusId AND c.cusCity IS NOT NULL
	GROUP BY c.cusCity, c.cusState
	ORDER BY 'Number of Customers that Posted a Review' DESC;

SELECT * FROM NumOfCustomerPostedReview_V

--Q2. What PriceLevel is the most popular among all restaurants?
GO
CREATE VIEW NumOfRestaurantbyPriceLevel_V
AS
	SELECT TOP(1) r.rstPriceLevel, COUNT(r.rstId) as 'Number of Restaurant by PriceLevel' 
	FROM [Hotspots.Restaurant] r
	GROUP BY r.rstPriceLevel
	ORDER BY 'Number of Restaurant by PriceLevel' DESC;

SELECT * FROM NumOfRestaurantbyPriceLevel_V

--Q3. Which restaurant, across all PriceLevels, has the highest rating?
GO
CREATE VIEW TopRestaurantBasedOnPrice_V
AS 
	Select r.rstId AS 'Restaurant ID', r.rstName AS 'Restaurant Name' , AVG(v.rvwStar) AS 'Average Rating' , r.rstPriceLevel AS 'Price Level'
	FROM [Hotspots.Restaurant] r 
		JOIN [Hotspots.Review] v 
		ON r.rstId = v.rstId 
	WHERE r.rstId=
		(SELECT TOP(1) re.rstId
		FROM [Hotspots.Restaurant] re JOIN [Hotspots.Review] rv 
		ON re.rstId = rv.rstId 
		WHERE re.rstPriceLevel=r.rstPriceLevel
		GROUP BY re.rstId
		)
	GROUP BY r.rstPriceLevel,r.rstId,r.rstName

SELECT * FROM TopRestaurantBasedOnPrice_V


--Q4. What are the names of the top 3 restaurants without considering their PriceLevel? 
GO
CREATE VIEW Top_3_Restaurants_V
AS 
	SELECT TOP (3) r.rstName AS 'Restaurant Name' , AVG(v.rvwStar) AS 'Average Rating' 
	FROM [Hotspots.Restaurant] r INNER JOIN [Hotspots.Review] v ON 
	r.rstId = v.rstId 
	GROUP BY r.rstName
	ORDER BY AVG(v.rvwStar) DESC;

SELECT * FROM Top_3_Restaurants_V

--Q5. Which restaurants has the longest operating hours in a week?
GO
CREATE VIEW LongestOperatingRestaurants_V
AS 
	SELECT TOP(1) r.rstName AS 'Restaurant Name', SUM(CASE 
															WHEN (oprEnd - oprStart) % 100 != 0 
																THEN FLOOR(oprEnd - oprStart) / 100 + 0.5
															WHEN oprEnd < oprStart
																THEN (oprEnd + 2400 - oprStart) / 100
															ELSE (oprEnd - oprStart) / 100 END ) AS 'Total Operating Hours in a Week'
	FROM [Hotspots.OperationTime] o, [Hotspots.Restaurant] r
	WHERE r.rstId = o.rstId
	GROUP BY o.rstId, r.rstName
	ORDER BY 'Total Operating Hours in a Week' DESC;

SELECT * FROM LongestOperatingRestaurants_V


