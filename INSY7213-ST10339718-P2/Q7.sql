-- Create a package to manage donation totals
CREATE OR REPLACE PACKAGE DonationManagement AS
    -- Procedure to update total donation values
    PROCEDURE UpdateDonatorTotals;

    -- Function to get the highest total donation value
    FUNCTION GetHighestTotal RETURN NUMBER;
END DonationManagement;
/

-- Create the package body
CREATE OR REPLACE PACKAGE BODY DonationManagement AS
    -- Procedure to update DONATOR_TOTALS
    PROCEDURE UpdateDonatorTotals AS
    BEGIN
        MERGE INTO DONATOR_TOTALS dt
        USING (SELECT d.DONATOR_ID, NVL(SUM(do.PRICE), 0) AS TotalValue
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
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error updating totals: ' || SQLERRM);
    END UpdateDonatorTotals;

    -- Function to get the highest total donation value
    FUNCTION GetHighestTotal RETURN NUMBER IS
        v_max_total NUMBER;
    BEGIN
        SELECT MAX(TOTAL_VALUE) INTO v_max_total
        FROM DONATOR_TOTALS;
        RETURN NVL(v_max_total, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error fetching highest total: ' || SQLERRM);
    END GetHighestTotal;
END DonationManagement;
/

-- Execute the procedure to update totals
EXEC DonationManagement.UpdateDonatorTotals;

-- Query to display donators with their totals and the highest total
SELECT 
    d.DONATOR_ID,
    d.FIRST_NAME,
    d.SURNAME,
    NVL(dt.TOTAL_VALUE, 0) AS TotalValue,
    DonationManagement.GetHighestTotal AS HighestTotal
FROM DONATOR d
LEFT JOIN DONATOR_TOTALS dt ON d.DONATOR_ID = dt.DONATOR_ID
ORDER BY d.DONATOR_ID;