-- delete rows with nulls in essential columns
DELETE FROM dbo.AllCountriesClimate_500
WHERE Record_ID IS NULL
   OR [Date] IS NULL
   OR Country IS NULL
   OR City IS NULL
   OR Temperature_C IS NULL
   OR Humidity_pct IS NULL
   OR Precipitation_mm IS NULL
   OR Air_Quality_Index_AQI IS NULL;

SELECT COUNT(*) AS Nulls_InEssentialColumns
FROM dbo.AllCountriesClimate_500
WHERE Record_ID IS NULL
   OR [Date] IS NULL
   OR Country IS NULL
   OR City IS NULL
   OR Temperature_C IS NULL
   OR Humidity_pct IS NULL
   OR Precipitation_mm IS NULL
   OR Air_Quality_Index_AQI IS NULL;
