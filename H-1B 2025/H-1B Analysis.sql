-- Generated the SELECT Query using "Script Table as" > "SELECT To"

USE [H-1B Analysis]
GO

SELECT [Line by line]
      ,[Fiscal Year   ]
      ,[Employer (Petitioner) Name]
      ,[Tax ID]
      ,[Industry (NAICS) Code]
      ,[Petitioner City]
      ,[Petitioner State]
      ,[Petitioner Zip Code]
      ,[New Employment Approval]
      ,[New Employment Denial]
      ,[Continuation Approval]
      ,[Continuation Denial]
      ,[Change with Same Employer Approval]
      ,[Change with Same Employer Denial]
      ,[New Concurrent Approval]
      ,[New Concurrent Denial]
      ,[Change of Employer Approval]
      ,[Change of Employer Denial]
      ,[Amended Approval]
      ,[Amended Denial]
  FROM [dbo].['Employer Information']

GO;

-- Removing the comma ',' in the [Line by line] column
-- Checking the data using SELECT

SELECT *, REPLACE([Line by line], ',', '') AS [Line by line2] 
FROM [dbo].['Employer Information']
ORDER BY 1;

-- Updating the data using UPDATE

UPDATE [dbo].['Employer Information']
SET [Line by line] = REPLACE([Line by line], ',', '');

SELECT *
FROM [dbo].['Employer Information']
ORDER BY 1;

-- Alter table

ALTER TABLE [dbo].['Employer Information']
ALTER COLUMN [Line by line] FLOAT;

-- Now the data looks clean to use
SELECT *
FROM [dbo].['Employer Information']
ORDER BY 1;

-- Exploring the Data

-- Column: [Employer (Petitioner) Name]

SELECT DISTINCT [Employer (Petitioner) Name]
FROM [dbo].['Employer Information'];

SELECT COUNT(DISTINCT[Employer (Petitioner) Name]) AS [Employer (Petitioner) Name Count]
FROM [dbo].['Employer Information']; -- 43494

SELECT [Employer (Petitioner) Name], COUNT(*) AS [Employer (Petitioner) Name Count]
FROM [dbo].['Employer Information']
GROUP BY [Employer (Petitioner) Name]
ORDER BY 2 DESC;

SELECT TOP 10
[Employer (Petitioner) Name], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Employer (Petitioner) Name]
ORDER BY 2 DESC;

-- Column: [Industry (NAICS) Code]

SELECT DISTINCT [Industry (NAICS) Code]
FROM [dbo].['Employer Information'];

SELECT COUNT(DISTINCT[Industry (NAICS) Code]) AS [Industry (NAICS) Code Count]
FROM [dbo].['Employer Information']; -- 21

SELECT [Industry (NAICS) Code], COUNT(*) AS [Industry (NAICS) Code Count]
FROM [dbo].['Employer Information']
GROUP BY [Industry (NAICS) Code]
ORDER BY 2 DESC;

SELECT TOP 5
[Industry (NAICS) Code], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Industry (NAICS) Code]
ORDER BY 2 DESC;

-- [Petitioner City], [Petitioner State], [Petitioner Zip Code]

SELECT DISTINCT [Petitioner City], [Petitioner State], [Petitioner Zip Code]
FROM [dbo].['Employer Information']
ORDER BY 2,1; -- 9223

SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [Petitioner City], [Petitioner State], [Petitioner Zip Code]
FROM [dbo].['Employer Information']
) A; -- 9223

-- [Petitioner City], [Petitioner State]

SELECT DISTINCT [Petitioner City], [Petitioner State]
FROM [dbo].['Employer Information']
ORDER BY 2,1; -- 5091

SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [Petitioner City], [Petitioner State]
FROM [dbo].['Employer Information']
) A; -- 5091

SELECT [Petitioner City], [Petitioner State], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Petitioner City], [Petitioner State]
ORDER BY 3 DESC;

SELECT TOP 10
[Petitioner City], [Petitioner State], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Petitioner City], [Petitioner State]
ORDER BY 3 DESC;

-- [Petitioner State]

SELECT DISTINCT [Petitioner State]
FROM [dbo].['Employer Information']
ORDER BY 1; -- 59

SELECT COUNT(*) AS COUNT FROM (
SELECT DISTINCT [Petitioner State]
FROM [dbo].['Employer Information']
) A; -- 59

SELECT [Petitioner State], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Petitioner State]
ORDER BY 2 DESC;

SELECT TOP 10
[Petitioner State], COUNT(*) AS [Count]
FROM [dbo].['Employer Information']
GROUP BY [Petitioner State]
ORDER BY 2 DESC;

--Remaining

SELECT SUM([New Employment Approval]) AS [Total New Employment Approval]
FROM [dbo].['Employer Information']; -- 76812

SELECT SUM([New Employment Denial]) AS [Total New Employment Denial]
FROM [dbo].['Employer Information']; -- 2378

SELECT SUM([Continuation Approval]) AS [Total Continuation Approval]
FROM [dbo].['Employer Information']; -- 91982

SELECT SUM([Continuation Denial]) AS [Total Continuation Denial]
FROM [dbo].['Employer Information']; -- 1378

SELECT SUM([Continuation Denial]) AS [Total Continuation Denial]
FROM [dbo].['Employer Information']; -- 1378

SELECT SUM([Change with Same Employer Approval]) AS [Total Change with Same Employer Approval]
FROM [dbo].['Employer Information']; -- 31318

SELECT SUM([Change with Same Employer Denial]) AS [Total Change with Same Employer Denial]
FROM [dbo].['Employer Information']; -- 459

SELECT SUM([New Concurrent Approval]) AS [Total New Concurrent Approval]
FROM [dbo].['Employer Information']; -- 1067

SELECT SUM([New Concurrent Denial]) AS [Total New Concurrent Denial]
FROM [dbo].['Employer Information']; -- 58

SELECT SUM([Change of Employer Approval]) AS [Total Change of Employer Approval]
FROM [dbo].['Employer Information']; -- 50765

SELECT SUM([Change of Employer Denial]) AS [Total Change of Employer Denial]
FROM [dbo].['Employer Information']; -- 955

SELECT SUM([Amended Approval]) AS [Total Amended Approval]
FROM [dbo].['Employer Information']; -- 52180

SELECT SUM([Amended Denial]) AS [Total Amended Denial]
FROM [dbo].['Employer Information']; -- 1110

-- Performing Analysis

-- 1. Top Employers by H-1B Approvals in 2025

SELECT TOP 10
[Employer (Petitioner) Name], SUM([New Employment Approval]) AS Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY Approvals DESC;

-- 2. Trending Industries (NAICS) by Number of Petitions Approved

SELECT TOP 10
[Industry (NAICS) Code], 
SUM([New Employment Approval] + [Continuation Approval] + [Change with Same Employer Approval] + [New Concurrent Approval] + [Change of Employer Approval] + [Amended Approval]) AS Total_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] >= 2025
GROUP BY [Industry (NAICS) Code]
ORDER BY Total_Approvals DESC;

-- 3. Geographic Trends: Top States by New Employment Approvals

SELECT TOP 5
[Petitioner State], SUM([New Employment Approval]) AS Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Petitioner State]
ORDER BY Approvals DESC;

-- 4. Denial Rates by Employer for Problem Statement Analysis

SELECT TOP 10
       [Employer (Petitioner) Name],
       SUM([New Employment Approval]) AS approvals,
       SUM([New Employment Denial]) AS denials,
       ROUND(SUM([New Employment Denial]) * 100.0 / NULLIF(SUM([New Employment Approval]) + SUM([New Employment Denial]), 0), 2) AS Denial_Rate_PCT
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
HAVING SUM([New Employment Denial]) > 5
ORDER BY Denial_Rate_PCT DESC;

-- 5. Industry Problem Patterns: High Denials by NAICS

SELECT TOP 10
       [Industry (NAICS) Code],
       SUM([New Employment Denial]) AS Total_Denials
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] >= 2025
GROUP BY [Industry (NAICS) Code]
ORDER BY Total_Denials DESC;

-- 6. ZIP Code Hotspots for New Employment Approvals

SELECT TOP 10
	[Petitioner Zip Code], 
	SUM([New Employment Approval]) AS Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Petitioner Zip Code]
ORDER BY Approvals DESC;

-- 7. Change of Employer Patterns

SELECT TOP 10
	[Employer (Petitioner) Name], 
	SUM([Change with Same Employer Approval]) AS Change_Employer_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY Change_Employer_Approvals DESC;

-- 8. Distribution of Petitions Across City

SELECT TOP 10
	[Petitioner City], 
	SUM([New Employment Approval]) AS Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Petitioner City]
ORDER BY Approvals DESC;

-- 9. Approvals vs. Denials by Major Employers

SELECT TOP 10
       [Employer (Petitioner) Name],
       SUM([New Employment Approval]) AS approvals,
       SUM([New Employment Denial]) AS denials
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY approvals DESC;

-- 10. Most Active NAICS Sectors for Change of Employer

SELECT TOP 10
	[Industry (NAICS) Code], 
	SUM([Change with Same Employer Approval]) AS Change_Employer_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Industry (NAICS) Code]
ORDER BY change_employer_approvals DESC;

-- 11. Proportion of Amended Petitions by Employer

SELECT TOP 10
	[Employer (Petitioner) Name], 
	SUM([Amended Approval]) AS Amended_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY Amended_Approvals DESC;

-- 12. State-level Denial Rate Comparison

SELECT [Petitioner State],
       SUM([New Employment Approval]) AS approvals,
       SUM([New Employment Denial]) AS denials,
       ROUND(SUM([New Employment Denial]) * 100.0 / NULLIF(SUM([New Employment Approval]) + SUM([New Employment Denial]), 0), 2) AS Denial_Rate_PCT
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Petitioner State]
ORDER BY Denial_Rate_PCT DESC;

-- 13. Top Industries Requesting Continuation

SELECT TOP 10
	[Industry (NAICS) Code], 
	SUM([Continuation Approval]) AS Continuation_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Industry (NAICS) Code]
ORDER BY Continuation_Approvals DESC;

-- 14. Employers with High Proportion of Denied Amended Petitions

SELECT TOP 10
	[Employer (Petitioner) Name], 
	SUM([Amended Denial]) AS Denied_Amendments
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY denied_amendments DESC;

-- 15. Major Employers' Use of Concurrent Approvals

SELECT TOP 10
	[Employer (Petitioner) Name], 
	SUM([New Concurrent Approval]) AS Concurrent_Approvals
FROM [dbo].['Employer Information']
WHERE [Fiscal Year] = 2025
GROUP BY [Employer (Petitioner) Name]
ORDER BY Concurrent_Approvals DESC;

---