SELECT 
    a.test,
    CASE 
        WHEN a.test = 'x' THEN (SELECT b.value FROM b WHERE b.some_column = a.some_column)
        WHEN a.test = 'y' THEN (SELECT c.value FROM c WHERE c.some_column = a.some_column)
    END AS result
FROM 
    a
