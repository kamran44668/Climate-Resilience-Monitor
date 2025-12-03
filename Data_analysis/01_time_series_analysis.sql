-- monthly temperature trends and extreme weather events
SELECT
    DATENAME(MONTH, [Date]) AS Month_Name,
    AVG(Temperature_C)      AS Avg_Temperature
FROM dbo.AllCountriesClimate_500
GROUP BY
    DATENAME(MONTH, [Date]),
    MONTH([Date])
ORDER BY
    MONTH([Date]);
GO

SELECT
    Country,
    YEAR([Date])            AS [Year],
    DATENAME(MONTH, [Date]) AS Month_Name,
    AVG(Temperature_C)      AS Avg_Temperature
FROM dbo.AllCountriesClimate_500
GROUP BY
    Country,
    YEAR([Date]),
    MONTH([Date]),
    DATENAME(MONTH, [Date])
ORDER BY
    Country,
    [Year],
    MONTH([Date]);
GO

SELECT
    DATENAME(MONTH, [Date]) AS Month_Name,
    COUNT(*)                 AS Event_Count
FROM dbo.AllCountriesClimate_500
WHERE Extreme_Weather_Events IS NOT NULL
  AND Extreme_Weather_Events <> 'None'
GROUP BY
    DATENAME(MONTH, [Date]),
    MONTH([Date])
ORDER BY
    MONTH([Date]);
GO
