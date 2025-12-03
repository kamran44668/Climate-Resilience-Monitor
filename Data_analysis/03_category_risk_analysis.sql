-- category and risk analysis on climate data
USE CLIMATE;
GO

SELECT
    CASE
        WHEN Temperature_C < 10 THEN 'Very Cold (<10°C)'
        WHEN Temperature_C BETWEEN 10 AND 15 THEN 'Cold (10-15°C)'
        WHEN Temperature_C BETWEEN 15 AND 20 THEN 'Moderate (15-20°C)'
        WHEN Temperature_C BETWEEN 20 AND 25 THEN 'Warm (20-25°C)'
        ELSE 'Hot (>25°C)'
    END AS Temperature_Range,
    Extreme_Weather_Events,
    COUNT(*) AS Event_Count
FROM dbo.AllCountriesClimate_500
WHERE Extreme_Weather_Events IS NOT NULL
  AND Extreme_Weather_Events <> 'None'
GROUP BY
    CASE
        WHEN Temperature_C < 10 THEN 'Very Cold (<10°C)'
        WHEN Temperature_C BETWEEN 10 AND 15 THEN 'Cold (10-15°C)'
        WHEN Temperature_C BETWEEN 15 AND 20 THEN 'Moderate (15-20°C)'
        WHEN Temperature_C BETWEEN 20 AND 25 THEN 'Warm (20-25°C)'
        ELSE 'Hot (>25°C)'
    END,
    Extreme_Weather_Events
ORDER BY
    Temperature_Range,
    Event_Count DESC;
GO

SELECT
    CASE
        WHEN Air_Quality_Index_AQI <= 50 THEN 'Good (0-50)'
        WHEN Air_Quality_Index_AQI BETWEEN 51 AND 100 THEN 'Moderate (51-100)'
        WHEN Air_Quality_Index_AQI BETWEEN 101 AND 150 THEN 'Unhealthy for Sensitive (101-150)'
        WHEN Air_Quality_Index_AQI BETWEEN 151 AND 200 THEN 'Unhealthy (151-200)'
        WHEN Air_Quality_Index_AQI BETWEEN 201 AND 300 THEN 'Very Unhealthy (201-300)'
        ELSE 'Hazardous (>300)'
    END AS AQI_Category,
    COUNT(*) AS Records,
    SUM(Population_Exposure) AS Total_Population_Exposure,
    ROUND(AVG(Temperature_C), 1) AS Avg_Temperature,
    ROUND(AVG(Infrastructure_Vulnerability_Score), 0) AS Avg_Vulnerability
FROM dbo.AllCountriesClimate_500
WHERE Air_Quality_Index_AQI IS NOT NULL
GROUP BY
    CASE
        WHEN Air_Quality_Index_AQI <= 50 THEN 'Good (0-50)'
        WHEN Air_Quality_Index_AQI BETWEEN 51 AND 100 THEN 'Moderate (51-100)'
        WHEN Air_Quality_Index_AQI BETWEEN 101 AND 150 THEN 'Unhealthy for Sensitive (101-150)'
        WHEN Air_Quality_Index_AQI BETWEEN 151 AND 200 THEN 'Unhealthy (151-200)'
        WHEN Air_Quality_Index_AQI BETWEEN 201 AND 300 THEN 'Very Unhealthy (201-300)'
        ELSE 'Hazardous (>300)'
    END
ORDER BY
    Records DESC;
GO

SELECT
    CASE
        WHEN Season IS NULL OR Season = 'NA' THEN 'Unknown'
        ELSE Season
    END AS Season,
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Extreme_Weather_Events IS NOT NULL
              AND Extreme_Weather_Events <> 'None'
             THEN 1 ELSE 0 END) AS Extreme_Weather_Count,
    ROUND(AVG(Temperature_C), 1) AS Avg_Temperature,
    ROUND(AVG(Precipitation_mm), 1) AS Avg_Precipitation,
    SUM(Population_Exposure) AS Total_Population_Exposure,
    SUM(Economic_Impact_Estimate) AS Total_Economic_Impact,
    ROUND(AVG(Infrastructure_Vulnerability_Score), 0) AS Avg_Vulnerability
FROM dbo.AllCountriesClimate_500
GROUP BY
    CASE
        WHEN Season IS NULL OR Season = 'NA' THEN 'Unknown'
        ELSE Season
    END
ORDER BY
    Extreme_Weather_Count DESC;
GO

SELECT
    CASE
        WHEN Biome_Type IS NULL OR Biome_Type = 'NA' THEN 'Unknown'
        ELSE Biome_Type
    END AS Biome_Type,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Country + '|' + City) AS Locations_Affected,
    SUM(CASE WHEN Extreme_Weather_Events IS NOT NULL
              AND Extreme_Weather_Events <> 'None'
             THEN 1 ELSE 0 END) AS Extreme_Weather_Count,
    ROUND(AVG(Temperature_C), 1) AS Avg_Temperature,
    ROUND(AVG(Precipitation_mm), 1) AS Avg_Precipitation,
    SUM(Economic_Impact_Estimate) AS Total_Economic_Impact_Estimate,
    ROUND(AVG(Infrastructure_Vulnerability_Score), 0) AS Avg_Vulnerability
FROM dbo.AllCountriesClimate_500
GROUP BY
    CASE
        WHEN Biome_Type IS NULL OR Biome_Type = 'NA' THEN 'Unknown'
        ELSE Biome_Type
    END
ORDER BY
    Extreme_Weather_Count DESC;
GO
