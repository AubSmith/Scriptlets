SELECT TOP (100) [ProductKey]
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
