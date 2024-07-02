SELECT TOP (10) [CustomerKey]
      ,[GeographyKey]
      ,[CustomerAlternateKey]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[EmailAddress]
      ,[DateFirstPurchase]
  FROM [AdventureWorksDW2022].[dbo].[DimCustomer];


SELECT TOP (10) [ProductKey]
      ,[ProductAlternateKey]
      ,[ProductSubcategoryKey]
      ,[StandardCost]
      ,[ListPrice]
      ,[DaysToManufacture]
      ,[ProductLine]
      ,[DealerPrice]
      ,[Class]
      ,[ModelName]
      ,[StartDate]
      ,[EndDate]
      ,[Status]
  FROM [AdventureWorksDW2022].[dbo].[DimProduct] as p
  WHERE p.Status IS NOT NULL
  ORDER BY p.StandardCost DESC;


SELECT TOP (10) [ResellerKey]
      ,[ResellerAlternateKey]
      ,[Phone]
      ,[BusinessType]
      ,[ResellerName]
      ,[OrderFrequency]
      ,[AnnualSales]
  FROM [AdventureWorksDW2022].[dbo].[DimReseller] AS R
  ORDER BY R.AnnualSales DESC;
