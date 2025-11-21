select distinct date_of_purchase
from railway;
 
 alter table railway
 alter column date_of_purchase date ; 

 select date_of_purchase
 from railway;


 select convert (time,time_of_purchase) as only_time
 from railway;

 select distinct time_of_purchase
 from railway;

 SELECT FORMAT(time_of_purchase,'HH:mm:ss') AS time_hh_mm_ss
FROM railway;
select distinct time_of_purchase
from railway;


 select date_of_journey
 from railway;
 alter table railway
 alter column date_of_journey date ; 
 select date_of_journey
 from railway;

 select convert (time,Departure_Time) as only_time
 from railway;

 SELECT FORMAT (Departure_Time,'HH:mm:ss') AS time_hh_mm_ss
FROM railway;

select  distinct Departure_Time 
from railway;

SELECT TOP 50 *
FROM railway;

SELECT COUNT(*) AS total_rows
FROM railway

SELECT 
      Date_of_Purchase,
      Time_of_Purchase,
      Purchase_Type,
      Payment_Method,
      Railcard,
      Ticket_Class,
      Ticket_Type,
      Price,
      Departure_Station,
      Arrival_Destination,
      Date_of_Journey,
      Departure_Time,
      Arrival_Time,
      Actual_Arrival_Time,
      Journey_Status,
      Reason_for_Delay,
      Refund_Request,
      COUNT(*) AS duplicate_count
FROM railway
GROUP BY 
      Date_of_Purchase,
      Time_of_Purchase,
      Purchase_Type,
      Payment_Method,
      Railcard,
      Ticket_Class,
      Ticket_Type,
      Price,
      Departure_Station,
      Arrival_Destination,
      Date_of_Journey,
      Departure_Time,
      Arrival_Time,
      Actual_Arrival_Time,
      Journey_Status,
      Reason_for_Delay,
      Refund_Request
HAVING COUNT(*) > 1;

WITH cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                  Date_of_Purchase,
                  Time_of_Purchase,
                  Purchase_Type,
                  Payment_Method,
                  Railcard,
                  Ticket_Class,
                  Ticket_Type,
                  Price,
                  Departure_Station,
                  Arrival_Destination,
                  Date_of_Journey,
                  Departure_Time,
                  Arrival_Time,
                  Actual_Arrival_Time,
                  Journey_Status,
                  Reason_for_Delay,
                  Refund_Request
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM railway
)
SELECT * FROM cte WHERE rn > 1;


WITH cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                  Date_of_Purchase,
                  Time_of_Purchase,
                  Purchase_Type,
                  Payment_Method,
                  Railcard,
                  Ticket_Class,
                  Ticket_Type,
                  Price,
                  Departure_Station,
                  Arrival_Destination,
                  Date_of_Journey,
                  Departure_Time,
                  Arrival_Time,
                  Actual_Arrival_Time,
                  Journey_Status,
                  Reason_for_Delay,
                  Refund_Request
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM railway
)
DELETE FROM cte WHERE rn > 1;


WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY 
                     Date_of_Purchase,
                     Time_of_Purchase,
                     Purchase_Type,
                     Payment_Method,
                     Railcard,
                     Ticket_Class,
                     Ticket_Type,
                     Price,
                     Departure_Station,
                     Arrival_Destination,
                     Date_of_Journey,
                     Departure_Time,
                     Arrival_Time,
                     Actual_Arrival_Time,
                     Journey_Status,
                     Reason_for_Delay,
                     Refund_Request
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM railway
)
SELECT COUNT(*) AS DuplicateRows
FROM cte
WHERE rn > 1;
DECLARE @sql NVARCHAR(MAX) = N'UPDATE railway SET ';

-- 
SELECT @sql = @sql + STRING_AGG(
    CASE 
        WHEN DATA_TYPE IN ('varchar', 'nvarchar', 'char', 'nchar', 'text', 'ntext') 
            THEN QUOTENAME(COLUMN_NAME) + ' = ISNULL(' + QUOTENAME(COLUMN_NAME) + ', ''unknown'')'
        WHEN DATA_TYPE IN ('int', 'bigint', 'smallint', 'decimal', 'numeric', 'float', 'real') 
            THEN QUOTENAME(COLUMN_NAME) + ' = ISNULL(' + QUOTENAME(COLUMN_NAME) + ', 0)'
        WHEN DATA_TYPE IN ('date', 'datetime', 'datetime2', 'smalldatetime') 
            THEN QUOTENAME(COLUMN_NAME) + ' = ISNULL(' + QUOTENAME(COLUMN_NAME) + ', ''1900-01-01'')'
        WHEN DATA_TYPE = 'time'
            THEN QUOTENAME(COLUMN_NAME) + ' = ISNULL(' + QUOTENAME(COLUMN_NAME) + ', ''00:00:00'')'
        ELSE QUOTENAME(COLUMN_NAME) + ' = ' + QUOTENAME(COLUMN_NAME)
    END, ', ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'railway';

--  WHERE ?????? ?????? ???? ????? ??? NULL
SET @sql = @sql + ' WHERE ' + 
    (SELECT STRING_AGG(QUOTENAME(COLUMN_NAME) + ' IS NULL', ' OR ')
     FROM INFORMATION_SCHEMA.COLUMNS
     WHERE TABLE_NAME = 'railway');

-- 
EXEC sp_executesql @sql;




UPDATE railway
SET 
    Purchase_Type = CASE WHEN LOWER(Purchase_Type) = 'null' THEN 'unknown' ELSE Purchase_Type END,
    Payment_Method = CASE WHEN LOWER(Payment_Method) = 'null' THEN 'unknown' ELSE Payment_Method END,
    Railcard = CASE WHEN LOWER(Railcard) = 'null' THEN 'unknown' ELSE Railcard END,
    Ticket_Class = CASE WHEN LOWER(Ticket_Class) = 'null' THEN 'unknown' ELSE Ticket_Class END,
    Ticket_Type = CASE WHEN LOWER(Ticket_Type) = 'null' THEN 'unknown' ELSE Ticket_Type END,
    Departure_Station = CASE WHEN LOWER(Departure_Station) = 'null' THEN 'unknown' ELSE Departure_Station END,
    Arrival_Destination = CASE WHEN LOWER(Arrival_Destination) = 'null' THEN 'unknown' ELSE Arrival_Destination END,
    Journey_Status = CASE WHEN LOWER(Journey_Status) = 'null' THEN 'unknown' ELSE Journey_Status END,
    Reason_for_Delay = CASE WHEN LOWER(Reason_for_Delay) = 'null' THEN 'unknown' ELSE Reason_for_Delay END,
    Refund_Request = CASE WHEN LOWER(Refund_Request) = 'null' THEN 'unknown' ELSE Refund_Request END
WHERE 
    LOWER(Purchase_Type) = 'null' OR
    LOWER(Payment_Method) = 'null' OR
    LOWER(Railcard) = 'null' OR
    LOWER(Ticket_Class) = 'null' OR
    LOWER(Ticket_Type) = 'null' OR
    LOWER(Departure_Station) = 'null' OR
    LOWER(Arrival_Destination) = 'null' OR
    LOWER(Journey_Status) = 'null' OR
    LOWER(Reason_for_Delay) = 'null' OR
    LOWER(Refund_Request) = 'null';

    select*
    from railway;
     

    UPDATE railway
SET 
    Purchase_Type = LTRIM(RTRIM(Purchase_Type)),
    Payment_Method = LTRIM(RTRIM(Payment_Method)),
    Railcard = LTRIM(RTRIM(Railcard)),
    Ticket_Class = LTRIM(RTRIM(Ticket_Class)),
    Ticket_Type = LTRIM(RTRIM(Ticket_Type)),
    Departure_Station = LTRIM(RTRIM(Departure_Station)),
    Arrival_Destination = LTRIM(RTRIM(Arrival_Destination)),
    Journey_Status = LTRIM(RTRIM(Journey_Status)),
    Reason_for_Delay = LTRIM(RTRIM(Reason_for_Delay)),
    Refund_Request = LTRIM(RTRIM(Refund_Request));


    select*
    from railway;

    UPDATE railway
SET 
    Purchase_Type = UPPER(Purchase_Type),
    Payment_Method = UPPER(Payment_Method),
    Railcard = UPPER(Railcard),
    Ticket_Class = UPPER(Ticket_Class),
    Ticket_Type = UPPER(Ticket_Type),
    Departure_Station = UPPER(Departure_Station),
    Arrival_Destination = UPPER(Arrival_Destination),
    Journey_Status = UPPER(Journey_Status),
    Reason_for_Delay = UPPER(Reason_for_Delay),
    Refund_Request = UPPER(Refund_Request);

    
    select*
    from railway;
SELECT *
FROM railway
WHERE Date_of_Journey < Date_of_Purchase;

SELECT *
FROM railway
WHERE Departure_Time >= Arrival_Time;


WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM railway
    WHERE Departure_Time >= Arrival_Time
)
SELECT *
FROM cte;

SELECT 
    Departure_Time, 
    Arrival_Time,
    DATEDIFF(MINUTE, Departure_Time, Arrival_Time) AS DiffMinutes
FROM railway
WHERE Departure_Time >= Arrival_Time;
--??????? ?????
SELECT *,
       CAST(Date_of_Journey AS DATETIME) + CAST(Departure_Time AS DATETIME) AS DepartureDateTime,
       CAST(Date_of_Journey AS DATETIME) + CAST(Arrival_Time AS DATETIME) AS ArrivalDateTime
FROM railway;



