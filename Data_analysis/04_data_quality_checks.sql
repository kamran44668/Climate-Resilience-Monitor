-- data quality checks on climate data
USE CLIMATE;
GO

PRINT '=== 1. Row Counts ===';

SELECT COUNT(*) AS TotalRows
FROM dbo.AllCountriesClimate_500;
GO

SELECT
    Country,
    COUNT(*) AS Row_Count
FROM dbo.AllCountriesClimate_500
GROUP BY
    Country
ORDER BY
    Row_Count DESC;
GO

PRINT '=== 2. NULL / NA Checks on Essential Columns ===';

SELECT
    COUNT(*) AS RowsWithNulls_InEssential
FROM dbo.AllCountriesClimate_500
WHERE Record_ID IS NULL
   OR [Date] IS NULL
   OR Country IS NULL
   OR City IS NULL
   OR Temperature_C IS NULL
   OR Humidity_pct IS NULL
   OR Precipitation_mm IS NULL
   OR Air_Quality_Index_AQI IS NULL;
GO

SELECT
    SUM(CASE WHEN Record_ID IS NULL THEN 1 ELSE 0 END)              AS Null_Record_ID,
    SUM(CASE WHEN [Date]     IS NULL THEN 1 ELSE 0 END)             AS Null_Date,
    SUM(CASE WHEN Country    IS NULL THEN 1 ELSE 0 END)             AS Null_Country,
    SUM(CASE WHEN City       IS NULL THEN 1 ELSE 0 END)             AS Null_City,
    SUM(CASE WHEN Temperature_C IS NULL THEN 1 ELSE 0 END)          AS Null_Temperature,
    SUM(CASE WHEN Humidity_pct   IS NULL THEN 1 ELSE 0 END)         AS Null_Humidity,
    SUM(CASE WHEN Precipitation_mm IS NULL THEN 1 ELSE 0 END)       AS Null_Precipitation,
    SUM(CASE WHEN Air_Quality_Index_AQI IS NULL THEN 1 ELSE 0 END)  AS Null_AQI
FROM dbo.AllCountriesClimate_500;
GO

PRINT '=== 3. NA / Unknown Checks (Season, Biome_Type) ===';

SELECT
    SUM(CASE WHEN Season IS NULL THEN 1 ELSE 0 END) AS Null_Season,
    SUM(CASE WHEN Season = 'NA' THEN 1 ELSE 0 END)  AS NA_Season
FROM dbo.AllCountriesClimate_500;
GO

SELECT
    SUM(CASE WHEN Biome_Type IS NULL THEN 1 ELSE 0 END) AS Null_Biome_Type,
    SUM(CASE WHEN Biome_Type = 'NA' THEN 1 ELSE 0 END)  AS NA_Biome_Type
FROM dbo.AllCountriesClimate_500;
GO

PRINT '=== 4. Range Sanity Checks ===';

SELECT
    MIN(Temperature_C) AS Min_Temperature,
    MAX(Temperature_C) AS Max_Temperature
FROM dbo.AllCountriesClimate_500;
GO

SELECT
    MIN(Humidity_pct) AS Min_Humidity,
    MAX(Humidity_pct) AS Max_Humidity
FROM dbo.AllCountriesClimate_500;
GO

SELECT
    MIN(Air_Quality_Index_AQI) AS Min_AQI,
    MAX(Air_Quality_Index_AQI) AS Max_AQI
FROM dbo.AllCountriesClimate_500;
GO

SELECT
    *
FROM dbo.AllCountriesClimate_500
WHERE (Humidity_pct < 0 OR Humidity_pct > 100)
   OR (Temperature_C < -80 OR Temperature_C > 70);
GO

PRINT '=== 5. Duplicate Record_ID Check ===';

SELECT
    Record_ID,
    COUNT(*) AS CountPerID
FROM dbo.AllCountriesClimate_500
GROUP BY
    Record_ID
HAVING
    COUNT(*) > 1;
GO
