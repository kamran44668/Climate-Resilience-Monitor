-- check nulls in essential columns
SELECT *
FROM dbo.AllCountriesClimate_500
WHERE Record_ID IS NULL
   OR [Date] IS NULL
   OR Country IS NULL
   OR City IS NULL
   OR Temperature_C IS NULL
   OR Humidity_pct IS NULL
   OR Precipitation_mm IS NULL
   OR Air_Quality_Index_AQI IS NULL;