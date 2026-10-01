-- =====================================================================
-- Food & Health Nutrition Analytics -- SQL Answers (Exercises 1-75)
-- Database: MySQL 8.0+  (CTEs and window functions need 8.0 or later)
-- Tables: Food_Categories, Foods, Nutrients, Food_Nutrients,
--         Health_Conditions, Dietary_Goals, Condition_Goals,
--         Food_Health_Benefits, Serving_Units, Dietary_Guidelines
-- =====================================================================

-- ---------- Part A: Basic SELECT and Filtering ----------

-- 1. All columns and all records from Foods
SELECT * FROM Foods;

-- 2. Selected columns from Foods
SELECT FoodID, FoodName, CaloriesPer100g, ProteinPer100g, FiberPer100g
FROM Foods;

-- 3. Foods with more than 10 g protein per 100 g
SELECT *
FROM Foods
WHERE ProteinPer100g > 10;

-- 4. Foods with at least 5 g fiber per 100 g
SELECT *
FROM Foods
WHERE FiberPer100g >= 5;

-- 5. Foods with fewer than 100 calories per 100 g
SELECT *
FROM Foods
WHERE CaloriesPer100g < 100;

-- ---------- Part B: Sorting and Limiting ----------

-- 6. Foods by protein, highest first
SELECT *
FROM Foods
ORDER BY ProteinPer100g DESC;

-- 7. Foods by calories, lowest first
SELECT *
FROM Foods
ORDER BY CaloriesPer100g ASC;

-- 8. Top 5 foods by protein
SELECT FoodName, ProteinPer100g
FROM Foods
ORDER BY ProteinPer100g DESC
LIMIT 5;

-- 9. Top 10 foods by fiber
SELECT FoodName, FiberPer100g
FROM Foods
ORDER BY FiberPer100g DESC
LIMIT 10;

-- 10. 5 foods with the lowest calories
SELECT FoodName, CaloriesPer100g
FROM Foods
ORDER BY CaloriesPer100g ASC
LIMIT 5;

-- ---------- Part C: Searching and Filtering ----------

-- 11. FoodName contains "Rice"
SELECT *
FROM Foods
WHERE FoodName LIKE '%Rice%';

-- 12. FoodName starts with "C"
SELECT *
FROM Foods
WHERE FoodName LIKE 'C%';

-- 13. Foods in CategoryID = 3
SELECT *
FROM Foods
WHERE CategoryID = 3;

-- 14. Protein between 5 and 15 g per 100 g
SELECT *
FROM Foods
WHERE ProteinPer100g BETWEEN 5 AND 15;

-- 15. Protein >= 10 AND fiber >= 5
SELECT *
FROM Foods
WHERE ProteinPer100g >= 10
  AND FiberPer100g >= 5;

-- ---------- Part D: Aggregate Functions ----------

-- 16. Total number of foods
SELECT COUNT(*) AS TotalFoods
FROM Foods;

-- 17. Average calories
SELECT AVG(CaloriesPer100g) AS AverageCalories
FROM Foods;

-- 18. Highest protein
SELECT MAX(ProteinPer100g) AS HighestProtein
FROM Foods;

-- 19. Lowest fiber
SELECT MIN(FiberPer100g) AS LowestFiber
FROM Foods;

-- 20. Final Phase I Challenge: average calories, protein and fiber
SELECT AVG(CaloriesPer100g) AS AverageCalories,
       AVG(ProteinPer100g)  AS AverageProtein,
       AVG(FiberPer100g)    AS AverageFiber
FROM Foods;

-- ---------- Part A: JOIN Operations ----------

-- 21. Food with its category name
SELECT f.FoodName, c.CategoryName
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID;

-- 22. Food, category and key nutrition values
SELECT f.FoodName, c.CategoryName, f.CaloriesPer100g, f.ProteinPer100g, f.FiberPer100g
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID;

-- 23. Foods with more than 10 g protein, with category
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
WHERE f.ProteinPer100g > 10;

-- 24. Every food with its nutrient name and amount per 100 g
SELECT f.FoodName, n.NutrientName, fn.AmountPer100g
FROM Foods f
JOIN Food_Nutrients fn ON f.FoodID = fn.FoodID
JOIN Nutrients n       ON fn.NutrientID = n.NutrientID;

-- 25. Foods containing Iron
SELECT f.FoodName, n.NutrientName, fn.AmountPer100g
FROM Foods f
JOIN Food_Nutrients fn ON f.FoodID = fn.FoodID
JOIN Nutrients n       ON fn.NutrientID = n.NutrientID
WHERE n.NutrientName = 'Iron';

-- ---------- Part B: Foods and Health Conditions ----------

-- 26. Foods associated with health conditions
SELECT f.FoodName, hc.ConditionName, fhb.SuitabilityScore, fhb.EvidenceLevel
FROM Food_Health_Benefits fhb
JOIN Foods f              ON fhb.FoodID = f.FoodID
JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID;

-- 27. Foods associated with Type 2 Diabetes
SELECT f.FoodName, dg.GoalName AS DietaryGoal, fhb.SuitabilityScore, fhb.EvidenceLevel
FROM Food_Health_Benefits fhb
JOIN Foods f              ON fhb.FoodID = f.FoodID
JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
JOIN Dietary_Goals dg     ON fhb.GoalID = dg.GoalID
WHERE hc.ConditionName = 'Type 2 Diabetes';

-- 28. Foods associated with Bone Health
SELECT f.FoodName, dg.GoalName AS DietaryGoal, fhb.SuitabilityScore, fhb.EvidenceLevel
FROM Food_Health_Benefits fhb
JOIN Foods f              ON fhb.FoodID = f.FoodID
JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
JOIN Dietary_Goals dg     ON fhb.GoalID = dg.GoalID
WHERE hc.ConditionName = 'Bone Health';

-- 29. Food-condition combinations with SuitabilityScore >= 85
SELECT f.FoodName, hc.ConditionName, fhb.SuitabilityScore, fhb.EvidenceLevel
FROM Food_Health_Benefits fhb
JOIN Foods f              ON fhb.FoodID = f.FoodID
JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
WHERE fhb.SuitabilityScore >= 85;

-- 30. Foods associated with the goal "Increase Dietary Fiber"
SELECT f.FoodName, dg.GoalName, fhb.SuitabilityScore
FROM Food_Health_Benefits fhb
JOIN Foods f          ON fhb.FoodID = f.FoodID
JOIN Dietary_Goals dg ON fhb.GoalID = dg.GoalID
WHERE dg.GoalName = 'Increase Dietary Fiber';

-- ---------- Part C: GROUP BY and HAVING ----------

-- 31. Number of different foods per health condition
SELECT hc.ConditionName, COUNT(DISTINCT fhb.FoodID) AS FoodCount
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName;

-- 32. Conditions with at least 5 different foods
SELECT hc.ConditionName, COUNT(DISTINCT fhb.FoodID) AS FoodCount
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName
HAVING COUNT(DISTINCT fhb.FoodID) >= 5;

-- 33. Average SuitabilityScore per health condition
SELECT hc.ConditionName, AVG(fhb.SuitabilityScore) AS AverageSuitabilityScore
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName;

-- 34. Conditions whose average SuitabilityScore is greater than 80
SELECT hc.ConditionName, AVG(fhb.SuitabilityScore) AS AverageSuitabilityScore
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName
HAVING AVG(fhb.SuitabilityScore) > 80;

-- 35. Number of different foods per dietary goal
SELECT dg.GoalName, COUNT(DISTINCT fhb.FoodID) AS FoodCount
FROM Dietary_Goals dg
JOIN Food_Health_Benefits fhb ON dg.GoalID = fhb.GoalID
GROUP BY dg.GoalID, dg.GoalName;

-- ---------- Part D: CASE Expressions ----------

-- 36. Protein classification
SELECT FoodName, ProteinPer100g,
       CASE
           WHEN ProteinPer100g >= 15 THEN 'Very High Protein'
           WHEN ProteinPer100g >= 10 THEN 'High Protein'
           WHEN ProteinPer100g >= 5  THEN 'Moderate Protein'
           ELSE 'Low Protein'
       END AS ProteinCategory
FROM Foods;

-- 37. Fiber classification
SELECT FoodName, FiberPer100g,
       CASE
           WHEN FiberPer100g >= 8 THEN 'Very High Fiber'
           WHEN FiberPer100g >= 5 THEN 'High Fiber'
           WHEN FiberPer100g >= 3 THEN 'Moderate Fiber'
           ELSE 'Low Fiber'
       END AS FiberCategory
FROM Foods;

-- 38. Nutrition profile
SELECT FoodName, ProteinPer100g, FiberPer100g,
       CASE
           WHEN ProteinPer100g >= 10 AND FiberPer100g >= 5 THEN 'High Protein & Fiber'
           WHEN ProteinPer100g >= 10 THEN 'High Protein'
           WHEN FiberPer100g >= 5 THEN 'High Fiber'
           ELSE 'Other'
       END AS NutritionProfile
FROM Foods;

-- ---------- Part E: Subqueries ----------

-- 39. Protein higher than the overall average
SELECT FoodName, ProteinPer100g
FROM Foods
WHERE ProteinPer100g > (SELECT AVG(ProteinPer100g) FROM Foods);

-- 40. Fiber higher than the overall average
SELECT FoodName, FiberPer100g
FROM Foods
WHERE FiberPer100g > (SELECT AVG(FiberPer100g) FROM Foods);

-- 41. Calories higher than the overall average
SELECT FoodName, CaloriesPer100g
FROM Foods
WHERE CaloriesPer100g > (SELECT AVG(CaloriesPer100g) FROM Foods);

-- ---------- Part F: Ranking and Window Functions ----------

-- 42. Rank foods by protein
SELECT FoodName, ProteinPer100g,
       RANK() OVER (ORDER BY ProteinPer100g DESC) AS ProteinRank
FROM Foods;

-- 43. RANK, DENSE_RANK and ROW_NUMBER on protein
SELECT FoodName, ProteinPer100g,
       RANK()       OVER (ORDER BY ProteinPer100g DESC) AS ProteinRank,
       DENSE_RANK() OVER (ORDER BY ProteinPer100g DESC) AS ProteinDenseRank,
       ROW_NUMBER() OVER (ORDER BY ProteinPer100g DESC) AS ProteinRowNumber
FROM Foods;

-- 44. Protein rank within each food category
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g,
       RANK() OVER (PARTITION BY f.CategoryID ORDER BY f.ProteinPer100g DESC) AS CategoryProteinRank
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID;

-- 45. Final Phase II Challenge: top 3 protein foods in every category
WITH RankedFoods AS (
    SELECT c.CategoryName, f.FoodName, f.ProteinPer100g,
           ROW_NUMBER() OVER (PARTITION BY f.CategoryID
                              ORDER BY f.ProteinPer100g DESC, f.FoodName) AS ProteinRank
    FROM Foods f
    JOIN Food_Categories c ON f.CategoryID = c.CategoryID
)
SELECT CategoryName, FoodName, ProteinPer100g, ProteinRank
FROM RankedFoods
WHERE ProteinRank <= 3
ORDER BY CategoryName, ProteinRank;

-- ---------- Part A: Advanced JOIN Analysis ----------

-- 46. Foods not mapped to any health condition
SELECT f.FoodID, f.FoodName
FROM Foods f
LEFT JOIN Food_Health_Benefits fhb ON f.FoodID = fhb.FoodID
WHERE fhb.FoodID IS NULL;

-- 47. Health conditions with no foods mapped
SELECT hc.ConditionID, hc.ConditionName
FROM Health_Conditions hc
LEFT JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
WHERE fhb.ConditionID IS NULL;

-- 48. Every food with its number of associated conditions (zero if none)
SELECT f.FoodName, COUNT(DISTINCT fhb.ConditionID) AS ConditionCount
FROM Foods f
LEFT JOIN Food_Health_Benefits fhb ON f.FoodID = fhb.FoodID
GROUP BY f.FoodID, f.FoodName;

-- 49. Foods associated with at least 3 different conditions
SELECT f.FoodName, COUNT(DISTINCT fhb.ConditionID) AS ConditionCount
FROM Foods f
JOIN Food_Health_Benefits fhb ON f.FoodID = fhb.FoodID
GROUP BY f.FoodID, f.FoodName
HAVING COUNT(DISTINCT fhb.ConditionID) >= 3;

-- 50. Foods with SuitabilityScore >= 80 for at least 2 different conditions
SELECT f.FoodName, COUNT(DISTINCT fhb.ConditionID) AS QualifyingConditions
FROM Foods f
JOIN Food_Health_Benefits fhb ON f.FoodID = fhb.FoodID
WHERE fhb.SuitabilityScore >= 80
GROUP BY f.FoodID, f.FoodName
HAVING COUNT(DISTINCT fhb.ConditionID) >= 2;

-- ---------- Part B: Nutrition Analysis ----------

-- 51. Foods with at least 10 g protein per 100 g
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
WHERE f.ProteinPer100g >= 10;

-- 52. Average calories, protein and fiber per category
SELECT c.CategoryName,
       AVG(f.CaloriesPer100g) AS AverageCalories,
       AVG(f.ProteinPer100g)  AS AverageProtein,
       AVG(f.FiberPer100g)    AS AverageFiber
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 53. Category with the highest average protein
SELECT c.CategoryName, AVG(f.ProteinPer100g) AS AverageProtein
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY AverageProtein DESC
LIMIT 1;

-- 54. Foods with protein >= 10 and fiber >= 5
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g, f.FiberPer100g
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
WHERE f.ProteinPer100g >= 10
  AND f.FiberPer100g >= 5;

-- 55. Calorie classification
SELECT FoodName, CaloriesPer100g,
       CASE
           WHEN CaloriesPer100g < 100 THEN 'Low Calorie'
           WHEN CaloriesPer100g < 200 THEN 'Moderate Calorie'
           WHEN CaloriesPer100g < 300 THEN 'High Calorie'
           ELSE 'Very High Calorie'
       END AS CalorieCategory
FROM Foods;

-- ---------- Part C: Health Condition Analysis ----------

-- 56. Average SuitabilityScore per condition, highest first
SELECT hc.ConditionName, AVG(fhb.SuitabilityScore) AS AverageScore
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName
ORDER BY AverageScore DESC;

-- 57. Condition with the highest average SuitabilityScore
SELECT hc.ConditionName, AVG(fhb.SuitabilityScore) AS AverageScore
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName
ORDER BY AverageScore DESC
LIMIT 1;

-- 58. Conditions with at least 5 different foods scoring 80 or higher
SELECT hc.ConditionName, COUNT(DISTINCT fhb.FoodID) AS QualifyingFoods
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
WHERE fhb.SuitabilityScore >= 80
GROUP BY hc.ConditionID, hc.ConditionName
HAVING COUNT(DISTINCT fhb.FoodID) >= 5;

-- 59. Highest-scoring food for each condition (ties are all shown)
WITH Ranked AS (
    SELECT hc.ConditionName, f.FoodName, fhb.SuitabilityScore,
           RANK() OVER (PARTITION BY hc.ConditionID
                        ORDER BY fhb.SuitabilityScore DESC) AS rnk
    FROM Food_Health_Benefits fhb
    JOIN Foods f              ON fhb.FoodID = f.FoodID
    JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
)
SELECT ConditionName, FoodName, SuitabilityScore
FROM Ranked
WHERE rnk = 1;

-- 60. Top 3 foods per condition by SuitabilityScore
WITH Ranked AS (
    SELECT hc.ConditionName, f.FoodName, fhb.SuitabilityScore,
           ROW_NUMBER() OVER (PARTITION BY hc.ConditionID
                              ORDER BY fhb.SuitabilityScore DESC, f.FoodName) AS Ranking
    FROM Food_Health_Benefits fhb
    JOIN Foods f              ON fhb.FoodID = f.FoodID
    JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
)
SELECT ConditionName, FoodName, SuitabilityScore, Ranking AS `Rank`
FROM Ranked
WHERE Ranking <= 3
ORDER BY ConditionName, Ranking;

-- ---------- Part D: CTE-Based Analysis ----------

-- 61. CTE: average protein per category
WITH CategoryProtein AS (
    SELECT c.CategoryName, AVG(f.ProteinPer100g) AS AverageProtein
    FROM Foods f
    JOIN Food_Categories c ON f.CategoryID = c.CategoryID
    GROUP BY c.CategoryID, c.CategoryName
)
SELECT CategoryName, AverageProtein
FROM CategoryProtein;

-- 62. Foods with protein above their own category average
WITH CategoryAvg AS (
    SELECT CategoryID, AVG(ProteinPer100g) AS CategoryAvgProtein
    FROM Foods
    GROUP BY CategoryID
)
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g, ca.CategoryAvgProtein
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
JOIN CategoryAvg ca    ON f.CategoryID = ca.CategoryID
WHERE f.ProteinPer100g > ca.CategoryAvgProtein;

-- 63. Protein AND fiber both above the overall averages
WITH OverallAvg AS (
    SELECT AVG(ProteinPer100g) AS AvgProtein,
           AVG(FiberPer100g)   AS AvgFiber
    FROM Foods
)
SELECT f.FoodName, f.ProteinPer100g, f.FiberPer100g
FROM Foods f
CROSS JOIN OverallAvg o
WHERE f.ProteinPer100g > o.AvgProtein
  AND f.FiberPer100g   > o.AvgFiber;

-- 64. Categories whose average protein and fiber both exceed the overall averages
WITH OverallAvg AS (
    SELECT AVG(ProteinPer100g) AS AvgProtein,
           AVG(FiberPer100g)   AS AvgFiber
    FROM Foods
),
CategoryAvg AS (
    SELECT c.CategoryName,
           AVG(f.ProteinPer100g) AS AverageProtein,
           AVG(f.FiberPer100g)   AS AverageFiber
    FROM Foods f
    JOIN Food_Categories c ON f.CategoryID = c.CategoryID
    GROUP BY c.CategoryID, c.CategoryName
)
SELECT ca.CategoryName, ca.AverageProtein, ca.AverageFiber
FROM CategoryAvg ca
CROSS JOIN OverallAvg o
WHERE ca.AverageProtein > o.AvgProtein
  AND ca.AverageFiber   > o.AvgFiber;

-- 65. Educational NutritionScore
WITH Scored AS (
    SELECT FoodName,
           (ProteinPer100g * 2) + (FiberPer100g * 3) - (CaloriesPer100g * 0.10) AS NutritionScore
    FROM Foods
)
SELECT FoodName, NutritionScore
FROM Scored
ORDER BY NutritionScore DESC;

-- ---------- Part E: Ranking and Window Functions ----------

-- 66. Rank foods by fiber within each category
SELECT c.CategoryName, f.FoodName, f.FiberPer100g,
       RANK() OVER (PARTITION BY f.CategoryID ORDER BY f.FiberPer100g DESC) AS FiberRank
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID;

-- 67. Top 2 fiber-rich foods in each category
WITH Ranked AS (
    SELECT c.CategoryName, f.FoodName, f.FiberPer100g,
           ROW_NUMBER() OVER (PARTITION BY f.CategoryID
                              ORDER BY f.FiberPer100g DESC, f.FoodName) AS Ranking
    FROM Foods f
    JOIN Food_Categories c ON f.CategoryID = c.CategoryID
)
SELECT CategoryName, FoodName, FiberPer100g, Ranking AS `Rank`
FROM Ranked
WHERE Ranking <= 2
ORDER BY CategoryName, Ranking;

-- 68. Rank conditions by average SuitabilityScore
SELECT hc.ConditionName,
       AVG(fhb.SuitabilityScore) AS AverageScore,
       RANK() OVER (ORDER BY AVG(fhb.SuitabilityScore) DESC) AS ConditionRank
FROM Health_Conditions hc
JOIN Food_Health_Benefits fhb ON hc.ConditionID = fhb.ConditionID
GROUP BY hc.ConditionID, hc.ConditionName;

-- 69. Protein with the previous food's protein (LAG)
SELECT FoodName, ProteinPer100g,
       LAG(ProteinPer100g) OVER (ORDER BY ProteinPer100g DESC, FoodName) AS PreviousProtein
FROM Foods
ORDER BY ProteinPer100g DESC, FoodName;

-- 70. Difference from the previous food's protein
SELECT FoodName, ProteinPer100g,
       LAG(ProteinPer100g) OVER (ORDER BY ProteinPer100g DESC, FoodName) AS PreviousProtein,
       LAG(ProteinPer100g) OVER (ORDER BY ProteinPer100g DESC, FoodName) - ProteinPer100g
           AS ProteinDifference
FROM Foods
ORDER BY ProteinPer100g DESC, FoodName;

-- ---------- Part F: Final Analytical Challenges ----------

-- 71. Highest-protein food in every category
WITH Ranked AS (
    SELECT c.CategoryName, f.FoodName, f.ProteinPer100g,
           ROW_NUMBER() OVER (PARTITION BY f.CategoryID
                              ORDER BY f.ProteinPer100g DESC, f.FoodName) AS rn
    FROM Foods f
    JOIN Food_Categories c ON f.CategoryID = c.CategoryID
)
SELECT CategoryName, FoodName, ProteinPer100g
FROM Ranked
WHERE rn = 1;

-- 72. Food with the highest SuitabilityScore for every dietary goal
WITH Ranked AS (
    SELECT dg.GoalName, f.FoodName, fhb.SuitabilityScore,
           ROW_NUMBER() OVER (PARTITION BY dg.GoalID
                              ORDER BY fhb.SuitabilityScore DESC, f.FoodName) AS rn
    FROM Food_Health_Benefits fhb
    JOIN Foods f          ON fhb.FoodID = f.FoodID
    JOIN Dietary_Goals dg ON fhb.GoalID = dg.GoalID
)
SELECT GoalName, FoodName, SuitabilityScore
FROM Ranked
WHERE rn = 1;

-- 73. Foods above their category's average protein, with the difference
WITH CategoryAvg AS (
    SELECT CategoryID, AVG(ProteinPer100g) AS CategoryAvgProtein
    FROM Foods
    GROUP BY CategoryID
)
SELECT f.FoodName, c.CategoryName, f.ProteinPer100g,
       ROUND(ca.CategoryAvgProtein, 2) AS CategoryAvgProtein,
       ROUND(f.ProteinPer100g - ca.CategoryAvgProtein, 2) AS DifferenceFromCategoryAvg
FROM Foods f
JOIN Food_Categories c ON f.CategoryID = c.CategoryID
JOIN CategoryAvg ca    ON f.CategoryID = ca.CategoryID
WHERE f.ProteinPer100g > ca.CategoryAvgProtein
ORDER BY c.CategoryName, DifferenceFromCategoryAvg DESC;

-- 74. Top 10 food-condition combinations by SuitabilityScore
SELECT f.FoodName, hc.ConditionName, fhb.SuitabilityScore, fhb.EvidenceLevel
FROM Food_Health_Benefits fhb
JOIN Foods f              ON fhb.FoodID = f.FoodID
JOIN Health_Conditions hc ON fhb.ConditionID = hc.ConditionID
ORDER BY fhb.SuitabilityScore DESC, f.FoodName, hc.ConditionName
LIMIT 10;

-- 75. Final Challenge: consolidated Food Health Analytics Report
WITH BenefitStats AS (
    SELECT FoodID,
           COUNT(DISTINCT ConditionID) AS ConditionCount,
           AVG(SuitabilityScore)       AS AvgSuitabilityScore
    FROM Food_Health_Benefits
    GROUP BY FoodID
)
SELECT f.FoodName,
       c.CategoryName,
       f.CaloriesPer100g,
       f.ProteinPer100g,
       f.FiberPer100g,
       COALESCE(bs.ConditionCount, 0)              AS NumberOfHealthConditions,
       ROUND(COALESCE(bs.AvgSuitabilityScore, 0), 2) AS AverageSuitabilityScore,
       RANK() OVER (PARTITION BY f.CategoryID
                    ORDER BY f.ProteinPer100g DESC) AS ProteinRankInCategory
FROM Foods f
JOIN Food_Categories c   ON f.CategoryID = c.CategoryID
LEFT JOIN BenefitStats bs ON f.FoodID = bs.FoodID
ORDER BY c.CategoryName, ProteinRankInCategory;
