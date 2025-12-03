-- ETL: staging CSVs → clean temp table → convert types → split into country tables

USE CLIMATE;
GO

IF OBJECT_ID('dbo.Climate_Staging') IS NULL
BEGIN
    CREATE TABLE dbo.Climate_Staging (
        [Record_ID]                          NVARCHAR(50),
        [Date]                               NVARCHAR(50),
        [Country]                            NVARCHAR(100),
        [City]                               NVARCHAR(100),
        [Temperature_C]                      NVARCHAR(50),
        [Humidity_pct]                       NVARCHAR(50),
        [Precipitation_mm]                   NVARCHAR(50),
        [Air_Quality_Index_AQI]              NVARCHAR(50),
        [Extreme_Weather_Events]             NVARCHAR(100),
        [Climate_Classification]             NVARCHAR(50),
        [Climate_Zone]                       NVARCHAR(50),
        [Biome_Type]                         NVARCHAR(50),
        [Heat_Index]                         NVARCHAR(50),
        [Wind_Speed]                         NVARCHAR(50),
        [Wind_Direction]                     NVARCHAR(50),
        [Season]                             NVARCHAR(50),
        [Population_Exposure]                NVARCHAR(50),
        [Economic_Impact_Estimate]           NVARCHAR(50),
        [Infrastructure_Vulnerability_Score] NVARCHAR(50)
    );
END;
GO

TRUNCATE TABLE dbo.Climate_Staging;

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Azerbaijan_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Georgia_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Iran_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Kazakhstan_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Russia_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Turkey_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');

BULK INSERT dbo.Climate_Staging
FROM 'C:\Users\kamran\Desktop\CAPSTONE PROJECTS\climate_change_project\datasets\Turkmenistan_climate_500.csv'
WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n', CODEPAGE='65001', DATAFILETYPE='char');
GO

IF OBJECT_ID('dbo.Climate_Template') IS NULL
BEGIN
    CREATE TABLE dbo.Climate_Template (
        [Record_ID]                          VARCHAR(20),
        [Date]                               DATE,
        [Country]                            VARCHAR(50),
        [City]                               VARCHAR(100),
        [Temperature_C]                      FLOAT,
        [Humidity_pct]                       FLOAT,
        [Precipitation_mm]                   FLOAT,
        [Air_Quality_Index_AQI]              INT,
        [Extreme_Weather_Events]             VARCHAR(100),
        [Climate_Classification]             VARCHAR(50),
        [Climate_Zone]                       VARCHAR(50),
        [Biome_Type]                         VARCHAR(50),
        [Heat_Index]                         FLOAT,
        [Wind_Speed]                         FLOAT,
        [Wind_Direction]                     VARCHAR(10),
        [Season]                             VARCHAR(20),
        [Population_Exposure]                INT,
        [Economic_Impact_Estimate]           FLOAT,
        [Infrastructure_Vulnerability_Score] INT
    );
END;
GO

IF OBJECT_ID('dbo.Azerbaijan_climate_500') IS NULL
    SELECT * INTO dbo.Azerbaijan_climate_500   FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Georgia_climate_500') IS NULL
    SELECT * INTO dbo.Georgia_climate_500      FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Iran_climate_500') IS NULL
    SELECT * INTO dbo.Iran_climate_500         FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Kazakhstan_climate_500') IS NULL
    SELECT * INTO dbo.Kazakhstan_climate_500   FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Russia_climate_500') IS NULL
    SELECT * INTO dbo.Russia_climate_500       FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Turkey_climate_500') IS NULL
    SELECT * INTO dbo.Turkey_climate_500       FROM dbo.Climate_Template WHERE 1=0;
IF OBJECT_ID('dbo.Turkmenistan_climate_500') IS NULL
    SELECT * INTO dbo.Turkmenistan_climate_500 FROM dbo.Climate_Template WHERE 1=0;
GO

TRUNCATE TABLE dbo.Azerbaijan_climate_500;
TRUNCATE TABLE dbo.Georgia_climate_500;
TRUNCATE TABLE dbo.Iran_climate_500;
TRUNCATE TABLE dbo.Kazakhstan_climate_500;
TRUNCATE TABLE dbo.Russia_climate_500;
TRUNCATE TABLE dbo.Turkey_climate_500;
TRUNCATE TABLE dbo.Turkmenistan_climate_500;
GO

SET DATEFORMAT dmy;

SELECT
    NULLIF(LTRIM(RTRIM(Record_ID)), '') AS Record_ID,
    TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM([Date])), '')) AS [Date],
    NULLIF(LTRIM(RTRIM(Country)), '') AS Country,
    NULLIF(LTRIM(RTRIM(City)), '') AS City,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Temperature_C, ',', ''), '')) AS Temperature_C,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Humidity_pct, ',', ''), '')) AS Humidity_pct,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Precipitation_mm, ',', ''), '')) AS Precipitation_mm,
    TRY_CONVERT(INT, NULLIF(REPLACE(Air_Quality_Index_AQI, ',', ''), '')) AS Air_Quality_Index_AQI,
    NULLIF(LTRIM(RTRIM(Extreme_Weather_Events)), '') AS Extreme_Weather_Events,
    NULLIF(LTRIM(RTRIM(Climate_Classification)), '') AS Climate_Classification,
    NULLIF(LTRIM(RTRIM(Climate_Zone)), '') AS Climate_Zone,
    NULLIF(LTRIM(RTRIM(Biome_Type)), '') AS Biome_Type,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Heat_Index, ',', ''), '')) AS Heat_Index,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Wind_Speed, ',', ''), '')) AS Wind_Speed,
    NULLIF(LTRIM(RTRIM(Wind_Direction)), '') AS Wind_Direction,
    NULLIF(LTRIM(RTRIM(Season)), '') AS Season,
    TRY_CONVERT(INT, NULLIF(REPLACE(Population_Exposure, ',', ''), '')) AS Population_Exposure,
    TRY_CONVERT(FLOAT, NULLIF(REPLACE(Economic_Impact_Estimate, ',', ''), '')) AS Economic_Impact_Estimate,
    TRY_CONVERT(INT, NULLIF(REPLACE(Infrastructure_Vulnerability_Score, ',', ''), '')) AS Infrastructure_Vulnerability_Score
INTO #Cleaned
FROM dbo.Climate_Staging;

WITH Dupes AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Record_ID, Country, City, [Date] ORDER BY Record_ID) AS rn
    FROM #Cleaned
)
DELETE FROM Dupes WHERE rn > 1;

INSERT INTO dbo.Azerbaijan_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Azerbaijan';

INSERT INTO dbo.Georgia_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Georgia';

INSERT INTO dbo.Iran_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Iran';

INSERT INTO dbo.Kazakhstan_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Kazakhstan';

INSERT INTO dbo.Russia_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Russia';

INSERT INTO dbo.Turkey_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Turkey';

INSERT INTO dbo.Turkmenistan_climate_500
SELECT * FROM #Cleaned WHERE Country = 'Turkmenistan';

DROP TABLE #Cleaned;
GO