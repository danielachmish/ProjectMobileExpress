-- קודם נמצא לקוח עם קריאות שירות
SELECT TOP 1 c.CusId, c.FullName, COUNT(s.SerCalId) as ServiceCallsCount
FROM T_Customers c
INNER JOIN T_ServiceCalls s ON c.CusId = s.CusId
GROUP BY c.CusId, c.FullName;

-- ננסה למחוק אותו
DELETE FROM T_Customers 
WHERE CusId = /* התוצאה מהשאילתה הקודמת */;