USE [H-1B Analysis]
GO

SELECT [Fiscal Year]
      ,[Employer]
      ,[Initial Approvals]
      ,[Initial Denials]
      ,[Continuing Approvals]
      ,[Continuing Denials]
      ,[NAICS]
      ,[Tax ID]
      ,[State]
      ,[City]
      ,[ZIP]
  FROM [dbo].[H1B_DataHubExport]

GO

-- 68919
-- 55429
-- 62874
-- 56222
-- 56079
-- 56595 rows transferred
-- 48544 rows transferred
-- 53129 rows transferred
-- 49786 rows transferred
-- 55666 rows transferred
-- 59441 rows transferred
-- 55239 rows transferred
-- 60806 rows transferred
-- 59983 rows transferred
-- 33332 rows transferred

-- To Check how many row were loaded by Fiscal Year

SELECT [Fiscal Year], COUNT(*) COUNTALL
FROM [dbo].[H1B_DataHubExport]
GROUP BY [Fiscal Year]
ORDER BY 1;

-- Due to some import issues in 2022 file, increasing the column size

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Employer] NVARCHAR(255);

-- Selecting new tables (Imported by Flat File Import instead of the Import and Export Wizard)

SELECT * FROM [dbo].[h1b_datahubexport-2022];
SELECT * FROM [dbo].[h1b_datahubexport-2023];

CREATE TABLE [dbo].[H1B_DataHubExport](
	[Fiscal Year] [varchar](50) NULL,
	[Employer] [nvarchar](255) NULL,
	[Initial Approvals] [varchar](50) NULL,
	[Initial Denials] [varchar](50) NULL,
	[Continuing Approvals] [varchar](50) NULL,
	[Continuing Denials] [varchar](50) NULL,
	[NAICS] [varchar](50) NULL,
	[Tax ID] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ZIP] [varchar](50) NULL
) ON [PRIMARY]
GO

-- Converting

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Fiscal Year] [smallint] NULL;

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Employer] [varchar](max) NULL;

-- Converting varchar to float [Initial Approvals]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Initial Approvals] [float] NULL;

SELECT DISTINCT REPLACE([Initial Approvals],',','') FROM [dbo].[H1B_DataHubExport] ORDER BY 1;

UPDATE [dbo].[H1B_DataHubExport]
SET [Initial Approvals] = REPLACE([Initial Approvals],',','');

-- Converting varchar to float [Initial Denials]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Initial Denials] [float] NULL;

SELECT DISTINCT REPLACE([Initial Denials],',','') FROM [dbo].[H1B_DataHubExport] ORDER BY 1;

UPDATE [dbo].[H1B_DataHubExport]
SET [Initial Denials] = REPLACE([Initial Denials],',','');

-- Converting varchar to float [Continuing Approvals]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Continuing Approvals] [float] NULL;

SELECT DISTINCT REPLACE([Continuing Approvals],',','') FROM [dbo].[H1B_DataHubExport] ORDER BY 1;

UPDATE [dbo].[H1B_DataHubExport]
SET [Continuing Approvals] = REPLACE([Continuing Approvals],',','');

-- Converting varchar to float [Continuing Denials]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [Continuing Denials] [float] NULL;

SELECT DISTINCT REPLACE([Continuing Denials],',','') FROM [dbo].[H1B_DataHubExport] ORDER BY 1;

UPDATE [dbo].[H1B_DataHubExport]
SET [Continuing Denials] = REPLACE([Continuing Denials],',','');

-- Converting varchar to tinyint [NAICS]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [NAICS] [tinyint] NULL;

-- Converting varchar to nvarchar 50 [State]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [State] [nvarchar](50) NULL;

-- Converting varchar to nvarchar 50 [City]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [City] [nvarchar](50) NULL;

-- Converting varchar to nvarchar 50 [City]

ALTER TABLE [dbo].[H1B_DataHubExport] 
ALTER COLUMN [ZIP] [int] NULL;

-- Converting varchar to nvarchar 50 [Tax_ID]

ALTER TABLE [dbo].[H1B_DataHubExport_Final]
ALTER COLUMN [Tax_ID] [smallint] NULL;

-------

-- To check which are causing the issue in varchar to float

SELECT DISTINCT TRY_CAST([Initial Denials] AS FLOAT) FROM [dbo].[H1B_DataHubExport];
SELECT DISTINCT CAST(ISNULL(NULLIF(TRIM([Initial Denials]), ''), '0') AS FLOAT) FROM [dbo].[H1B_DataHubExport];

SELECT *
FROM [dbo].[H1B_DataHubExport]
WHERE TRY_CAST([Continuing Approvals] AS FLOAT) IS NULL
      AND [Continuing Approvals] IS NOT NULL
      AND LTRIM(RTRIM([Continuing Approvals])) <> '';

-------

-- Checking if all the data are inline for next steps

SELECT * FROM [dbo].[H1B_DataHubExport]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2020]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2021]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2022]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2023]; -- 832044

---

CREATE TABLE [dbo].[H1B_DataHubExport_Final](
	[Fiscal Year] [smallint] NULL,
	[Employer] [varchar](max) NULL,
	[Initial Approvals] [float] NULL,
	[Initial Denials] [float] NULL,
	[Continuing Approvals] [float] NULL,
	[Continuing Denials] [float] NULL,
	[NAICS] [tinyint] NULL,
	[Tax ID] [varchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[ZIP] [int] NULL
);

---

-- Combing all the data into a single table

INSERT INTO [dbo].[H1B_DataHubExport_Final]
SELECT * FROM [dbo].[H1B_DataHubExport]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2020]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2021]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2022]
UNION ALL
SELECT * FROM [dbo].[h1b_datahubexport-2023]; -- (832044 rows affected)

---

SELECT [Fiscal Year], COUNT(*) COUNTALL
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY 1;

-- Exploring the Data [Employer]

SELECT DISTINCT [Employer]
FROM [dbo].[H1B_DataHubExport_Final];
---
SELECT COUNT(DISTINCT[Employer]) AS [Employer Count]
FROM [dbo].[H1B_DataHubExport_Final]; -- 346135

SELECT [Employer], COUNT(*) AS [Employer Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
ORDER BY 2 DESC;

SELECT TOP 10
[Employer], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
ORDER BY 2 DESC;

-- Exploring the Data [NAICS]

SELECT DISTINCT [NAICS]
FROM [dbo].[H1B_DataHubExport_Final];
---
SELECT COUNT(DISTINCT[NAICS]) AS [NAICS Count]
FROM [dbo].[H1B_DataHubExport_Final]; -- 25

SELECT [NAICS], COUNT(*) AS [NAICS Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [NAICS]
ORDER BY 2 DESC;

SELECT TOP 5
[NAICS], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [NAICS]
ORDER BY 2 DESC;

-- Exploring the Data [City], [State], [ZIP]

SELECT DISTINCT [City], [State], [ZIP]
FROM [dbo].[H1B_DataHubExport_Final]
ORDER BY 2,1; -- 24301
---
SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [City], [State], [ZIP]
FROM [dbo].[H1B_DataHubExport_Final]
) A; -- 24301

-- Exploring the Data [City], [State]

SELECT DISTINCT [City], [State]
FROM [dbo].[H1B_DataHubExport_Final]
ORDER BY 2,1; -- 12841
---
SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [City], [State]
FROM [dbo].[H1B_DataHubExport_Final]
) A; -- 12841

SELECT [City], [State], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [City], [State]
ORDER BY 3 DESC;

SELECT TOP 10
[City], [State], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [City], [State]
ORDER BY 3 DESC;

-- Exploring the Data [State]

SELECT DISTINCT [State]
FROM [dbo].[H1B_DataHubExport_Final]
ORDER BY 1; -- 62
---
SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [State]
FROM [dbo].[H1B_DataHubExport_Final]
) A; -- 62

SELECT [State], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [State]
ORDER BY 2 DESC;

SELECT TOP 10
[State], COUNT(*) AS [Count]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [State]
ORDER BY 2 DESC;

-- Exploring the Data - other columns

SELECT SUM([Initial Approvals]) AS [Total Initial Approvals]
FROM [dbo].[H1B_DataHubExport_Final]; -- 1411508 > 1675596

SELECT SUM([Initial Denials]) AS [Total Initial Denials]
FROM [dbo].[H1B_DataHubExport_Final]; -- 164511 > 188454

SELECT SUM([Continuing Approvals]) AS [Total Continuing Approvals]
FROM [dbo].[H1B_DataHubExport_Final]; -- 2563437 > 3201196

SELECT SUM([Continuing Denials]) AS [Total Continuing Denials]
FROM [dbo].[H1B_DataHubExport_Final]; -- 142306 > 171745

--- Performing Analysis

-- 1. Total Initial Approvals Each Year

SELECT 
[Fiscal Year], 
SUM([Initial Approvals]) AS Total_Initial_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY [Fiscal Year];

-- 2. Top 10 Employers by Initial Approvals (All Years)

SELECT TOP 10 
[Employer], 
SUM([Initial Approvals]) AS Total_Initial_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
ORDER BY Total_Initial_Approvals DESC;

-- 3. Year-over-Year Growth/Decline in Initial Approvals

SELECT a.[Fiscal Year], a.Total_Initial_Approvals, 
  a.Total_Initial_Approvals - b.Total_Initial_Approvals AS YoY_Change
FROM (
  SELECT [Fiscal Year], SUM([Initial Approvals]) AS Total_Initial_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Fiscal Year]
) a
LEFT JOIN (
  SELECT [Fiscal Year], SUM([Initial Approvals]) AS Total_Initial_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Fiscal Year]
) b
ON a.[Fiscal Year] = b.[Fiscal Year] + 1
ORDER BY a.[Fiscal Year];

-- 4. Denial Rates by NAICS Industry

SELECT [NAICS], 
  SUM([Initial Denials]) AS Total_Initial_Denials,
  SUM([Initial Approvals]) AS Total_Initial_Approvals,
  (CAST(SUM([Initial Denials]) AS FLOAT) / NULLIF(SUM([Initial Approvals]) + SUM([Initial Denials]), 0)) AS Initial_Denial_Rate
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [NAICS]
ORDER BY Initial_Denial_Rate DESC;

-- 5. States with Highest H-1B Activity

SELECT TOP 10
	[State], 
	SUM([Initial Approvals] + [Initial Denials] + [Continuing Approvals] + [Continuing Denials]) AS Total_Activity
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [State]
ORDER BY Total_Activity DESC;

-- 6. Top Cities for H-1B Approvals

SELECT TOP 10
	[City], 
	SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [City]
ORDER BY Total_Approvals DESC;

-- 7. Employer with Highest Denial Rate

SELECT TOP 10
  [Employer],
  SUM([Initial Denials]) AS Total_Denials,
  SUM([Initial Approvals]) AS Total_Approvals,
  (CAST(SUM([Initial Denials]) AS FLOAT) / NULLIF(SUM([Initial Denials]) + SUM([Initial Approvals]), 0)) AS Denial_Rate
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
HAVING SUM([Initial Denials]) + SUM([Initial Approvals]) > 50
ORDER BY Denial_Rate DESC;

-- 8. Yearly Trends for Continuing Approvals

SELECT [Fiscal Year], SUM([Continuing Approvals]) AS Total_Continuing_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY [Fiscal Year];

-- 9. Employers Operating in Multiple States

SELECT TOP 10
[Employer], 
COUNT(DISTINCT [State]) AS State_Count
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
HAVING COUNT(DISTINCT [State]) > 1
ORDER BY State_Count DESC;

-- 10. ZIP Codes with Most H-1B Activity

SELECT TOP 10
[ZIP], 
SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [ZIP]
ORDER BY Total_Approvals DESC;

-- 11. Average Approvals Per Employer

SELECT AVG(Total_Approvals) AS Avg_Approvals_Per_Employer
FROM (
  SELECT [Employer], SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Employer]
) a;

-- 12. NAICS Sectors with Highest H-1B Approvals

SELECT TOP 10 
[NAICS], 
SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [NAICS]
ORDER BY Total_Approvals DESC;

-- 13. Initial vs. Continuing Approval Trend Over Years

SELECT [Fiscal Year], 
    SUM([Initial Approvals]) AS Initial_Approvals,
    SUM([Continuing Approvals]) AS Continuing_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY [Fiscal Year];

-- 14. Top 10 Employers in Most Recent Year

SELECT TOP 10 
[Employer], 
SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
WHERE 
[Fiscal Year] = 
(SELECT MAX([Fiscal Year]) FROM [dbo].[H1B_DataHubExport_Final])
GROUP BY [Employer]
ORDER BY Total_Approvals DESC;

-- 15. Denial Rate Trend Over Years

SELECT [Fiscal Year], 
  SUM([Initial Denials]) AS Denials, 
  SUM([Initial Approvals]) AS Approvals,
  (CAST(SUM([Initial Denials]) AS FLOAT) / NULLIF(SUM([Initial Denials]) + SUM([Initial Approvals]),0)) AS Annual_Denial_Rate
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY [Fiscal Year];

-- 16. Employers Filing in Only One NAICS Sector

SELECT [Employer], COUNT(DISTINCT [NAICS]) AS NAICS_Count
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Employer]
HAVING COUNT(DISTINCT [NAICS]) = 1
ORDER BY [Employer]

---

-- Advance Data Analysis

-- 1. Moving Average of Initial Approvals Over Years

SELECT 
  [Fiscal Year],
  SUM([Initial Approvals]) AS Approvals,
  AVG(SUM([Initial Approvals])) OVER (
    ORDER BY [Fiscal Year] 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS Moving_Avg_Initial_Approvals
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year]
ORDER BY [Fiscal Year];

-- 2. Top Employer Each Year (Correlated Subquery)

SELECT t.[Fiscal Year], t.[Employer], t.Total_Approvals
FROM (
  SELECT 
    [Fiscal Year],
    [Employer],
    SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Fiscal Year], [Employer]
) t
WHERE t.Total_Approvals = (
    SELECT TOP 1 SUM([Initial Approvals] + [Continuing Approvals])
    FROM [dbo].[H1B_DataHubExport_Final] t2
    WHERE t2.[Fiscal Year] = t.[Fiscal Year]
    GROUP BY t2.[Employer]
    ORDER BY SUM([Initial Approvals] + [Continuing Approvals]) DESC
)
ORDER BY t.[Fiscal Year];

-- 3. Year-on-Year % Growth of Initial Approvals

WITH cte AS (
  SELECT 
    [Fiscal Year], 
    SUM([Initial Approvals]) AS Total_Initial_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Fiscal Year]
)
SELECT 
  [Fiscal Year],
  Total_Initial_Approvals,
  LAG(Total_Initial_Approvals, 1) OVER (ORDER BY [Fiscal Year]) AS Prev_Year_Approvals,
  CASE 
    WHEN LAG(Total_Initial_Approvals, 1) OVER (ORDER BY [Fiscal Year]) > 0 THEN
      ROUND(
        100.0 * (Total_Initial_Approvals - LAG(Total_Initial_Approvals, 1) OVER (ORDER BY [Fiscal Year]))
        / LAG(Total_Initial_Approvals, 1) OVER (ORDER BY [Fiscal Year]),2)
    ELSE NULL END AS YoY_Percent_Change
FROM cte
ORDER BY [Fiscal Year];

-- 4. Share of Initial Denials by State (Window Function Partitioned by Year)

SELECT 
  [Fiscal Year], [State],
  SUM([Initial Denials]) AS Denials,
  SUM([Initial Denials]) * 1.0 / SUM(SUM([Initial Denials])) OVER (PARTITION BY [Fiscal Year]) AS State_Denial_Share
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY [Fiscal Year], [State]
ORDER BY [Fiscal Year], State_Denial_Share DESC;

-- 5. Employers with an Increasing Trend in Approvals Over 3 Years

WITH EmployerYear AS (
  SELECT
    [Employer],
    [Fiscal Year],
    SUM([Initial Approvals] + [Continuing Approvals]) AS Total_Approvals
  FROM [dbo].[H1B_DataHubExport_Final]
  GROUP BY [Employer], [Fiscal Year]
)
SELECT e1.[Employer], e1.[Fiscal Year], e1.Total_Approvals
FROM EmployerYear e1
JOIN EmployerYear e2 ON e1.[Employer] = e2.[Employer] AND e1.[Fiscal Year] = e2.[Fiscal Year] + 1
JOIN EmployerYear e3 ON e1.[Employer] = e3.[Employer] AND e1.[Fiscal Year] = e3.[Fiscal Year] + 2
WHERE e1.Total_Approvals > e2.Total_Approvals 
  AND e2.Total_Approvals > e3.Total_Approvals
ORDER BY e1.[Employer], e1.[Fiscal Year];

-- Data Visualization

SELECT COUNT(*) COUTNALL FROM [dbo].[H1B_DataHubExport_Final];

SELECT 
[Fiscal Year],
[Employer],
SUM([Initial Approvals]) AS [Initial Approvals],
SUM([Initial Denials]) AS [Initial Denials],
SUM([Continuing Approvals]) AS [Continuing Approvals],
SUM([Continuing Denials]) AS [Continuing Denials],
[NAICS],
[Tax ID],
[State],
[City],
[ZIP]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY
[Fiscal Year],
[Employer],
[NAICS],
[Tax ID],
[State],
[City],
[ZIP]; -- 8,18,210

-- Without ZIP, less granular

SELECT 
[Fiscal Year],
[Employer],
SUM([Initial Approvals]) AS [Initial Approvals],
SUM([Initial Denials]) AS [Initial Denials],
SUM([Continuing Approvals]) AS [Continuing Approvals],
SUM([Continuing Denials]) AS [Continuing Denials],
[NAICS],
[Tax ID],
[State],
[City]
FROM [dbo].[H1B_DataHubExport_Final]
GROUP BY
[Fiscal Year],
[Employer],
[NAICS],
[Tax ID],
[State],
[City]; -- 8,05,401