-- spatial analysis on climate data
USE CLIMATE;
GO

SELECT
    Country,
    COUNT(*) AS Event_Count
FROM dbo.AllCountriesClimate_500
WHERE Extreme_Weather_Events IS NOT NULL
  AND Extreme_Weather_Events <> 'None'
GROUP BY
    Country
ORDER BY
    Event_Count DESC;
GO

SELECT TOP 5
    Country,
    City,
    ROUND(AVG(Air_Quality_Index_AQI), 0) AS Avg_AQI,
    SUM(CASE WHEN Air_Quality_Index_AQI > 200 THEN 1 ELSE 0 END) AS Days_Above_200_AQI,
    SUM(Population_Exposure)            AS Total_Population_Exposure,
    ROUND(AVG(Temperature_C), 1)        AS Avg_Temperature
FROM dbo.AllCountriesClimate_500
WHERE [Date] BETWEEN '2025-03-03' AND '2025-03-07'
GROUP BY
    Country,
    City
HAVING
    AVG(Air_Quality_Index_AQI) > 100
ORDER BY
    Avg_AQI DESC;
GO

SELECT
    Country,
    City,
    COUNT(*) AS Extreme_Event_Days,
    COUNT(DISTINCT Extreme_Weather_Events) AS Distinct_Event_Types,
    ROUND(AVG(Temperature_C), 1) AS Avg_Temperature,
    SUM(Population_Exposure) AS Total_Population_Exposure,
    SUM(Economic_Impact_Estimate) AS Total_Economic_Impact,
    ROUND(AVG(Infrastructure_Vulnerability_Score), 0) AS Avg_Vulnerability
FROM dbo.AllCountriesClimate_500
WHERE Extreme_Weather_Events IS NOT NULL
  AND Extreme_Weather_Events <> 'None'
GROUP BY
    Country,
    City
ORDER BY
    Total_Economic_Impact DESC;
GO
