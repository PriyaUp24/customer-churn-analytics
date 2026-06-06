CREATE DATABASE db_Churn

USE db_Churn
SELECT DB_NAME() AS CurrentDatabase

USE db_Churn

-- ================================================
-- CUSTOMER CHURN ANALYSIS
-- Author: Priya Upadhyay
-- Date: June 2026
-- Description: Data exploration and cleaning for
--              telecom customer churn analytics
-- ================================================


-- -----------------------------------------------
-- STEP 1: DATA EXPLORATION
-- -----------------------------------------------

-- Check total row count
SELECT COUNT(*) AS TotalRows FROM stg_Churn

USE db_Churn

SELECT TOP 10 * FROM stg_Churn

-- Check customer status breakdown
SELECT Customer_Status, 
       COUNT(*) AS TotalCount,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM stg_Churn), 1) AS Percentage
FROM stg_Churn
GROUP BY Customer_Status

-- Check churn by contract type
SELECT Contract,
       COUNT(*) AS TotalCount,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM stg_Churn), 1) AS Percentage
FROM stg_Churn
GROUP BY Contract
ORDER BY TotalCount DESC

-- Check revenue by customer status
SELECT Customer_Status,
       COUNT(*) AS TotalCustomers,
       ROUND(SUM(Total_Revenue), 0) AS TotalRevenue,
       ROUND(SUM(Total_Revenue) * 100.0 / (SELECT SUM(Total_Revenue) FROM stg_Churn), 1) AS RevenuePercentage
FROM stg_Churn
GROUP BY Customer_Status

-- Check top churning states
SELECT State,
       COUNT(*) AS TotalCount,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM stg_Churn), 1) AS Percentage
FROM stg_Churn
GROUP BY State
ORDER BY TotalCount DESC

-- Check gender split
SELECT Gender,
       COUNT(*) AS TotalCount,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM stg_Churn), 1) AS Percentage
FROM stg_Churn
GROUP BY Gender

-- -----------------------------------------------
-- STEP 2: NULL CHECK
-- -----------------------------------------------

-- Check null counts across all columns
SELECT
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Customer_ID_Nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Nulls,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
    SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS Married_Nulls,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS State_Nulls,
    SUM(CASE WHEN Number_of_Referrals IS NULL THEN 1 ELSE 0 END) AS Referrals_Nulls,
    SUM(CASE WHEN Tenure_in_Months IS NULL THEN 1 ELSE 0 END) AS Tenure_Nulls,
    SUM(CASE WHEN Value_Deal IS NULL THEN 1 ELSE 0 END) AS Value_Deal_Nulls,
    SUM(CASE WHEN Phone_Service IS NULL THEN 1 ELSE 0 END) AS Phone_Service_Nulls,
    SUM(CASE WHEN Multiple_Lines IS NULL THEN 1 ELSE 0 END) AS Multiple_Lines_Nulls,
    SUM(CASE WHEN Internet_Service IS NULL THEN 1 ELSE 0 END) AS Internet_Service_Nulls,
    SUM(CASE WHEN Internet_Type IS NULL THEN 1 ELSE 0 END) AS Internet_Type_Nulls,
    SUM(CASE WHEN Online_Security IS NULL THEN 1 ELSE 0 END) AS Online_Security_Nulls,
    SUM(CASE WHEN Online_Backup IS NULL THEN 1 ELSE 0 END) AS Online_Backup_Nulls,
    SUM(CASE WHEN Device_Protection_Plan IS NULL THEN 1 ELSE 0 END) AS Device_Protection_Nulls,
    SUM(CASE WHEN Premium_Support IS NULL THEN 1 ELSE 0 END) AS Premium_Support_Nulls,
    SUM(CASE WHEN Streaming_TV IS NULL THEN 1 ELSE 0 END) AS Streaming_TV_Nulls,
    SUM(CASE WHEN Streaming_Movies IS NULL THEN 1 ELSE 0 END) AS Streaming_Movies_Nulls,
    SUM(CASE WHEN Streaming_Music IS NULL THEN 1 ELSE 0 END) AS Streaming_Music_Nulls,
    SUM(CASE WHEN Unlimited_Data IS NULL THEN 1 ELSE 0 END) AS Unlimited_Data_Nulls,
    SUM(CASE WHEN Contract IS NULL THEN 1 ELSE 0 END) AS Contract_Nulls,
    SUM(CASE WHEN Paperless_Billing IS NULL THEN 1 ELSE 0 END) AS Paperless_Billing_Nulls,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Payment_Method_Nulls,
    SUM(CASE WHEN Monthly_Charge IS NULL THEN 1 ELSE 0 END) AS Monthly_Charge_Nulls,
    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END) AS Total_Charges_Nulls,
    SUM(CASE WHEN Total_Refunds IS NULL THEN 1 ELSE 0 END) AS Total_Refunds_Nulls,
    SUM(CASE WHEN Total_Extra_Data_Charges IS NULL THEN 1 ELSE 0 END) AS Extra_Data_Nulls,
    SUM(CASE WHEN Total_Long_Distance_Charges IS NULL THEN 1 ELSE 0 END) AS Long_Distance_Nulls,
    SUM(CASE WHEN Total_Revenue IS NULL THEN 1 ELSE 0 END) AS Total_Revenue_Nulls,
    SUM(CASE WHEN Customer_Status IS NULL THEN 1 ELSE 0 END) AS Customer_Status_Nulls,
    SUM(CASE WHEN Churn_Category IS NULL THEN 1 ELSE 0 END) AS Churn_Category_Nulls,
    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Nulls
FROM stg_Churn



DROP TABLE IF EXISTS prod_Churn


-- -----------------------------------------------
-- STEP 3: CREATE CLEAN PRODUCTION TABLE
-- -----------------------------------------------

-- Fix nulls and insert clean data into prod_Churn
SELECT
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'None') AS Value_Deal,
    Phone_Service,
    ISNULL(CAST(Multiple_Lines AS VARCHAR(50)), 'No') AS Multiple_Lines,
    Internet_Service,
    ISNULL(CAST(Internet_Type AS VARCHAR(50)), 'None') AS Internet_Type,
    ISNULL(CAST(Online_Security AS VARCHAR(50)), 'No') AS Online_Security,
    ISNULL(CAST(Online_Backup AS VARCHAR(50)), 'No') AS Online_Backup,
    ISNULL(CAST(Device_Protection_Plan AS VARCHAR(50)), 'No') AS Device_Protection_Plan,
    ISNULL(CAST(Premium_Support AS VARCHAR(50)), 'No') AS Premium_Support,
    ISNULL(CAST(Streaming_TV AS VARCHAR(50)), 'No') AS Streaming_TV,
    ISNULL(CAST(Streaming_Movies AS VARCHAR(50)), 'No') AS Streaming_Movies,
    ISNULL(CAST(Streaming_Music AS VARCHAR(50)), 'No') AS Streaming_Music,
    ISNULL(CAST(Unlimited_Data AS VARCHAR(50)), 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others') AS Churn_Category,
    ISNULL(Churn_Reason, 'Others') AS Churn_Reason
INTO prod_Churn
FROM stg_Churn


-- Verify no nulls remain in prod_Churn
SELECT COUNT(*) AS Value_Deal_Nulls 
FROM prod_Churn 
WHERE Value_Deal IS NULL

-- Verify total rows
SELECT COUNT(*) AS TotalRows FROM prod_Churn



-- -----------------------------------------------
-- STEP 4: CREATE VIEWS FOR POWER BI AND PYTHON
-- -----------------------------------------------

-- Drop views if they already exist
DROP VIEW IF EXISTS vw_ChurnData
DROP VIEW IF EXISTS vw_JoinData
GO

-- View 1: Historical customers (Stayed + Churned)
-- Used for: Power BI dashboard + Python model training
CREATE VIEW vw_ChurnData AS
SELECT * FROM prod_Churn
WHERE Customer_Status IN ('Churned', 'Stayed')
GO

-- View 2: New customers (Joined)
-- Used for: Python prediction scoring
CREATE VIEW vw_JoinData AS
SELECT * FROM prod_Churn
WHERE Customer_Status = 'Joined'
GO


-- Should return 6007
SELECT COUNT(*) AS ChurnData_Rows FROM vw_ChurnData

-- Should return 411
SELECT COUNT(*) AS JoinData_Rows FROM vw_JoinData



