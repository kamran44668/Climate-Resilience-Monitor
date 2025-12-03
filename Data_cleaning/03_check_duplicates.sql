-- check duplicate record IDs
SELECT record_id
FROM dbo.AllCountriesClimate_500
GROUP BY record_id
HAVING COUNT(*) > 1;