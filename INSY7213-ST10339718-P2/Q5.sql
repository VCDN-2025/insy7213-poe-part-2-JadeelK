-- Create the DONATOR_TOTALS table
CREATE TABLE DONATOR_TOTALS (
    DONATOR_ID NUMBER PRIMARY KEY,
    TOTAL_VALUE NUMBER(10, 2)
);

-- Create a stored procedure to calculate and update total donation value per donator
CREATE OR REPLACE PROCEDURE UpdateDonatorTotals AS
BEGIN
    -- Update or insert into the DONATOR_TOTALS table
    MERGE INTO DONATOR_TOTALS dt
    USING (SELECT d.DONATOR_ID, SUM(do.PRICE) AS TotalValue
           FROM DONATOR d
           LEFT JOIN DONATION do ON d.DONATOR_ID = do.DONATOR_ID
           GROUP BY d.DONATOR_ID) src
    ON (dt.DONATOR_ID = src.DONATOR_ID)
    WHEN MATCHED THEN
        UPDATE SET dt.TOTAL_VALUE = src.TotalValue
    WHEN NOT MATCHED THEN
        INSERT (DONATOR_ID, TOTAL_VALUE)
        VALUES (src.DONATOR_ID, src.TotalValue);
    COMMIT;
END;
/

-- Execute the stored procedure
EXEC UpdateDonatorTotals;

-- Query to verify the results
SELECT 
    d.DONATOR_ID,
    d.FIRST_NAME,
    d.SURNAME,
    dt.TOTAL_VALUE
FROM DONATOR d
LEFT JOIN DONATOR_TOTALS dt ON d.DONATOR_ID = dt.DONATOR_ID
ORDER BY d.DONATOR_ID;