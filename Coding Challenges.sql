-- Challenge 1

SELECT A.PurchaseOrderID,
	   A.PurchaseOrderDetailID,
	   A.OrderQty,
	   A.UnitPrice,
	   A.LineTotal,
	   B.OrderDate,
	   [OrderSizeCategory] = CASE
			WHEN A.OrderQty > 500 THEN 'Large'
			WHEN A.OrderQty > 50 THEN 'Medium'
			ELSE 'Small'
			END,
		[ProductName] = C.Name,
		[Subcategory] = ISNULL(D.Name, 'None'),
		[Category] = ISNULL(E.Name, 'None')
FROM Purchasing.PurchaseOrderDetail A
INNER JOIN Purchasing.PurchaseOrderHeader B ON A.PurchaseOrderID = B.PurchaseOrderID
INNER JOIN Production.Product C ON A.ProductID = C.ProductID
LEFT JOIN Production.ProductSubcategory D ON C.ProductSubcategoryID = D.ProductSubcategoryID
LEFT JOIN Production.ProductCategory E ON D.ProductCategoryID = E.ProductCategoryID
WHERE MONTH(B.OrderDate) = 12


-- Challenge 2 

SELECT [OrderType] = 'Purchase',
	   A.PurchaseOrderID AS [OrderID],
	   A.PurchaseOrderDetailID AS [OrderDetailID],
	   A.OrderQty,
	   A.UnitPrice,
	   A.LineTotal,
	   B.OrderDate,
	   [OrderSizeCategory] = CASE
			WHEN A.OrderQty > 500 THEN 'Large'
			WHEN A.OrderQty > 50 THEN 'Medium'
			ELSE 'Small'
			END,
		[ProductName] = C.Name,
		[Subcategory] = ISNULL(D.Name, 'None'),
		[Category] = ISNULL(E.Name, 'None')
FROM Purchasing.PurchaseOrderDetail A
INNER JOIN Purchasing.PurchaseOrderHeader B ON A.PurchaseOrderID = B.PurchaseOrderID
INNER JOIN Production.Product C ON A.ProductID = C.ProductID
LEFT JOIN Production.ProductSubcategory D ON C.ProductSubcategoryID = D.ProductSubcategoryID
LEFT JOIN Production.ProductCategory E ON D.ProductCategoryID = E.ProductCategoryID
WHERE MONTH(B.OrderDate) = 12

UNION ALL

SELECT [OrderType] = 'Sales',
	   A.SalesOrderID AS [OrderID],
	   A.SalesOrderDetailID AS [OrderDetailID],
	   A.OrderQty,
	   A.UnitPrice,
	   A.LineTotal,
	   B.OrderDate,
	   [OrderSizeCategory] = CASE
			WHEN A.OrderQty > 500 THEN 'Large'
			WHEN A.OrderQty > 50 THEN 'Medium'
			ELSE 'Small'
			END,
		[ProductName] = C.Name,
		[Subcategory] = ISNULL(D.Name, 'None'),
		[Category] = ISNULL(E.Name, 'None')
FROM Sales.SalesOrderDetail A
INNER JOIN Sales.SalesOrderHeader B ON A.SalesOrderID = B.SalesOrderID
INNER JOIN Production.Product C ON A.ProductID = C.ProductID
LEFT JOIN Production.ProductSubcategory D ON C.ProductSubcategoryID = D.ProductSubcategoryID
LEFT JOIN Production.ProductCategory E ON D.ProductCategoryID = E.ProductCategoryID
WHERE MONTH(B.OrderDate) = 12

ORDER BY OrderDate DESC


-- Challenge 3

SELECT A.BusinessEntityID,
	   A.PersonType,
	   [FullName] = A.FirstName + ' ' + CASE WHEN A.MiddleName IS NOT NULL THEN A.MiddleName + ' ' ELSE '' END + A.LastName,
	   [Address] = B.AddressLine1,
	   B.City,
	   B.PostalCode,
	   [State] = C.Name,
	   [Country] = D.Name
FROM Person.Person A
JOIN Person.BusinessEntityAddress E ON A.BusinessEntityID = E.BusinessEntityID
JOIN Person.Address B ON E.AddressID = B.AddressID
JOIN Person.StateProvince C ON B.StateProvinceID = C.StateProvinceID
JOIN Person.CountryRegion D ON C.CountryRegionCode = D.CountryRegionCode
WHERE A.PersonType = 'SP' OR (B.PostalCode LIKE '9%' AND LEN(B.PostalCode) = 5 AND D.Name = 'United States')


-- Challenge 4

SELECT A.BusinessEntityID,
	   A.PersonType,
	   [FullName] = A.FirstName + ' ' + CASE WHEN A.MiddleName IS NOT NULL THEN A.MiddleName + ' ' ELSE '' END + A.LastName,
	   [JobTitle] = ISNULL(F.JobTitle, 'None'),
	   [JobCategory] = CASE 
			WHEN F.JobTitle LIKE '%Manager%' OR F.JobTitle LIKE '%President%' OR F.JobTitle LIKE '%Executive%' THEN 'Management' 
			WHEN F.JobTitle LIKE '%Engineer%' THEN 'Engineering'
			WHEN F.JobTitle LIKE '%Production%' THEN 'Production'
			WHEN F.JobTitle LIKE '%Marketing%' THEN 'Marketing'
			WHEN F.JobTitle IS NULL THEN 'N/A'
			WHEN F.JobTitle IN ('Recruiter', 'Benefits Specialist', 'Human Resources Administrative Assistant') THEN 'Human Resources'
			ELSE 'Other'
			END,
	   [Address] = B.AddressLine1,
	   B.City,
	   B.PostalCode,
	   [State] = C.Name,
	   [Country] = D.Name
FROM Person.Person A
JOIN Person.BusinessEntityAddress E ON A.BusinessEntityID = E.BusinessEntityID
JOIN Person.Address B ON E.AddressID = B.AddressID
JOIN Person.StateProvince C ON B.StateProvinceID = C.StateProvinceID
JOIN Person.CountryRegion D ON C.CountryRegionCode = D.CountryRegionCode
LEFT JOIN HumanResources.Employee F ON A.BusinessEntityID = F.BusinessEntityID

WHERE A.PersonType = 'SP' OR (B.PostalCode LIKE '9%' AND LEN(B.PostalCode) = 5 AND D.Name = 'United States')
