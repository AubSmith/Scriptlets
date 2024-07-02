SELECT TOP (100) [ResellerKey]
      ,[ResellerAlternateKey]
      ,[Phone]
      ,[BusinessType]
      ,[ResellerName]
      ,[OrderFrequency]
      ,[AnnualSales]
  FROM [AdventureWorksDW2022].[dbo].[DimReseller] AS R
  ORDER BY R.AnnualSales DESC;
