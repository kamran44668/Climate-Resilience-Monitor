-- merged table creation
SELECT *
INTO dbo.AllCountriesClimate_500
FROM (
    SELECT * FROM dbo.Azerbaijan_climate_500
    UNION ALL
    SELECT * FROM dbo.Georgia_climate_500
    UNION ALL
    SELECT * FROM dbo.Iran_climate_500
    UNION ALL
    SELECT * FROM dbo.Kazakhstan_climate_500
    UNION ALL
    SELECT * FROM dbo.Russia_climate_500
    UNION ALL
    SELECT * FROM dbo.Turkey_climate_500
    UNION ALL
    SELECT * FROM dbo.Turkmenistan_climate_500
) AS merged;