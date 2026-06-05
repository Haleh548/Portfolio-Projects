select *  FROM zepto_v2;
-- duplicates
SELECT *
FROM zepto_v1
WHERE name IS NULL
OR 
Category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- data clening
-- convert mrp and discountedSellingPrice to rupees
UPDATE zepto_v1
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice /100.0;
 SELECT mrp, discountedSellingPrice 
 FROM zepto_v1;
 
 -- data analysis
 
 -- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT(name), discountPercent
FROM zepto_v1
ORDER BY discountPercent DESC
LIMIT 10;
 
 -- Q2.What are the Products with High MRP but Out of Stock
 SELECT `name`, mrp
 FROM zepto_v1
 WHERE outOfStock='True' AND mrp>100
 ORDER BY mrp DESC;
 
 -- Q3.Calculate Estimated Revenue for each category
 SELECT category, SUM(discountedSellingPrice) as total_rev
 FROM zepto_v1
 GROUP BY category
 ORDER BY total_rev;
 
 -- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%
 SELECT DISTINCT(`name`), discountedSellingPrice
 FROM zepto_v1
 WHERE mrp >300 AND discountedSellingPrice < 5
 ORDER BY discountedSellingPrice DESC;
 
 -- Q5. Identify the top 5 categories offering the highest average discount percentage.
 SELECT category, ROUND(AVG(discountPercent),2) AS avg_discount
 FROM zepto_v2
 GROUP BY category
 ORDER BY avg_discount DESC;
 
 -- Q6. Find the price per gram for products above 100g and sort by best value.
 SELECT ROUND((discountedSellingPrice/weightInGms),2) AS price_per_gram, name, weightInGms, discountedSellingPrice
 FROM zepto_v2
 WHERE weightInGms >=100
 ORDER BY price_per_gram DESC;
 
 -- Q7.Group the products into categories like Low, Medium, Bulk.
 SELECT name, weightInGms,
 CASE
    WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
    END AS weight_category
FROM zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category  
SELECT category, SUM(weightInGms*availableQuantity) AS total_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_weight;