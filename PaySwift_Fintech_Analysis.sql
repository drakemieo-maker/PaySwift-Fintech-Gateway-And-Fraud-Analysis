USE PaySwift_Fintech;

SELECT 
	Payment_Channel, 
    COUNT(Tx_ID) AS TOTAL_Transactions,
    SUM(CASE WHEN Tx_Status= 'Failed' THEN 1 ELSE 0 END) AS Failed_Count,
    AVG(Processing_Seconds) AS AVG_Speed_Seconds
FROM Payment_Logs
GROUP BY Payment_Channel
ORDER BY Failed_Count DESC;

SELECT 	
	Customer_Bank, 
    COUNT(Tx_ID) AS Total_Transactions,
    SUM(CASE WHEN Error_Code = 'Bank_Timeout' THEN 1 ELSE 0 END) AS Timeout_Count,
    AVG(Processing_Seconds) AS AVG_Speed_Seconds
FROM Payment_Logs
GROUP BY Customer_Bank
ORDER BY Timeout_Count DESC;

SELECT 	
	Customer_ID, 
    COUNT(Tx_ID) AS Failed_Transactions,
    SUM(CASE WHEN Tx_Status = 'Declined_Fraud' THEN 1 ELSE 0 END) AS Declined_Count,
    AVG(Processing_Seconds) AS AVG_Speed_Seconds
FROM Payment_Logs
GROUP BY Customer_ID
HAVING COUNT(Tx_ID) > 1
ORDER BY Declined_Count DESC;

SELECT 
    m.Merchant_Name,
    m.Industry,
    COUNT(p.Tx_ID) AS Total_Transactions,
    SUM(CASE WHEN p.Tx_Status = 'Success' THEN p.Amount_Naira ELSE 0 END) AS Successful_Revenue_Naira,
    SUM(CASE WHEN p.Tx_Status != 'Success' THEN p.Amount_Naira ELSE 0 END) AS Lost_or_Blocked_Naira
FROM Payment_Logs p
INNER JOIN Merchants m ON p.Merchant_ID = m.Merchant_ID
GROUP BY m.Merchant_Name, m.Industry
ORDER BY Lost_or_Blocked_Naira DESC;

