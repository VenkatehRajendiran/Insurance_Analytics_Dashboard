# INSURANCE ANALYTICS using mysql - Group 4

/*Ten KPIs ----
1. Yearly Meeting Count
2. No. of Meetings by Account Executive
3. No. of Invoices by Account Executive
4. Top Open Opportunity
5. Stage Funnel by Revenue
6. Cross Sell, New, Renewal - (Target, Achieved, New)
7. total claim amount
8. no. of claims
9. total amount by claim status
10. Division of customer by gender

*/



 # KPI 1- Yearly Meeting Count
SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y')) AS Year,
    COUNT(*) AS 'Yearly Meeting Count'
FROM
    meeting
GROUP BY year
ORDER BY year;

# KPI 2- No of Meetings by Account Executive

SELECT `Account Executive`, 
       COUNT(*) AS Total_Meetings
FROM meeting
GROUP BY `Account Executive`
ORDER BY Total_Meetings DESC;

# KPI 3 - No of Invoices by Account Executive

SELECT `Account Executive`, COUNT(`invoice_number`) AS `Total Invoices`
FROM invoice
GROUP BY `Account Executive`
ORDER BY `Total Invoices` DESC;

# KPI 4- Top 5 Opportunity by Revenue

SELECT `opportunity_name` AS "Opportunity", `Account Executive`, concat(cast( `revenue_amount`/1000000 as decimal(10,2)),"M") AS "Revenue Amount"
FROM opportunity
ORDER BY `revenue_amount` DESC
LIMIT 5;

# KPI 5 - Stage Funnel by Revenue

SELECT stage AS "Stage", concat(cast(SUM(revenue_amount)/1000000 as decimal(10,2)),"M") AS "Total_Revenue"
FROM opportunity
GROUP BY stage
ORDER BY Total_Revenue DESC;

# kPI 6 -- cross sell,New,Renewal- (Target,Achieved,New)
WITH CombinedData AS (
    SELECT `Account Exe ID`, Amount, income_class FROM brokerage
    UNION ALL
    SELECT `Account Exe ID`, Amount, income_class FROM fees)

SELECT 
    Category,
    Target"TARGET in Million",
	Achieved "ACHIEVED in Million",
	Invoice"INVOICE in Million"
   
    FROM (
   SELECT 
    'Cross Sell' AS Category,
    (SELECT cast(SUM(`Cross sell bugdet`)/1000000 as decimal(10,2)) FROM `individual budgets`) AS Target,
    ROUND((SELECT cast(SUM(Amount)/1000000 as decimal(10,2)) FROM `CombinedData` WHERE income_class = 'Cross Sell'),0) AS Achieved,
    (SELECT cast(SUM(Amount)/1000000 as decimal(10,2)) FROM `invoice` WHERE income_class = 'Cross Sell') AS Invoice
UNION ALL
SELECT 
    'New',
    (SELECT cast(SUM(`New Budget`)/1000000 as decimal (10,2)) FROM `individual budgets`),
    ROUND((SELECT cast(SUM(Amount)/1000000 as decimal (10,2)) FROM `CombinedData` WHERE income_class = 'New'),0),
    (SELECT cast(SUM(Amount)/1000000 as decimal (10,2)) FROM `invoice` WHERE income_class = 'New')
UNION ALL
SELECT 
    'Renewal',
    (SELECT cast(SUM(`Renewal Budget`)/1000000 as decimal (10,2)) FROM `individual budgets`),
    ROUND((SELECT cast(SUM(Amount)/1000000 as decimal (10,2)) FROM `CombinedData` WHERE income_class = 'Renewal'),0),
    (SELECT cast(SUM(Amount)/1000000 as decimal (10,2)) FROM `invoice` WHERE income_class = 'Renewal')
) AS KPI_Calculations;

#kpi 7. Total claim amount
select concat(cast(sum(`Claim Amount`)/1000000 as decimal(10,2)),"M") as total_claim_amount from `claims policy data`;

 #kpi 8. no. of claims
 select concat(cast(count(`Claim ID`)/1000 as decimal(10,0)),"K") as num_of_claims from `claims policy data`;
 
 #kpi 9. total amount by claim status
 select `Claim Status`,concat(cast(sum(`Claim Amount`)/1000000 as decimal (10,0)),"M") total_amount from `claims policy data` group by`Claim Status`;

#kpi10. division of customer by gender
select Gender, count(`Customer ID`) customer from `customer policy data` group by Gender;
