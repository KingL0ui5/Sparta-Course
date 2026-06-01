SELECT 
    table_name AS [Table Name], 
    column_name AS [Header/Column Name]
FROM 
    information_schema.columns
ORDER BY 
    table_name, ordinal_position;