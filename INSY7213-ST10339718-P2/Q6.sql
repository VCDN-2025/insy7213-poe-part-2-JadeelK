-- Create a table to track total donation value per donator (if not already created)
CREATE TABLE DONATOR_TOTALS (
    DONATOR_ID NUMBER PRIMARY KEY,
    TOTAL_VALUE NUMBER(10, 2)
);

-- Create a trigger to update DONATOR_TOTALS when a new donation is inserted or updated
CREATE OR REPLACE TRIGGER UpdateDonatorTotalTrigger
AFTER INSERT OR UPDATE OF PRICE ON DONATION
FOR EACH ROW
DECLARE
    v_total NUMBER(10, 2);
BEGIN
    -- Calculate the new total for the donator
    SELECT NVL(SUM(:NEW.PRICE), 0) INTO v_total
    FROM DONATION
    WHERE DONATOR_ID = :NEW.DONATOR_ID;

    -- Update or insert into DONATOR_TOTALS
    MERGE INTO DONATOR_TOTALS dt
    USING DUAL
    ON (dt.DONATOR_ID = :NEW.DONATOR_ID)
    WHEN MATCHED THEN
        UPDATE SET dt.TOTAL_VALUE = v_total
    WHEN NOT MATCHED THEN
        INSERT (DONATOR_ID, TOTAL_VALUE)
        VALUES (:NEW.DONATOR_ID, v_total);
END;
/

-- Insert a new donation to test the trigger
INSERT INTO DONATION VALUES (7117, 20113, 'New Donation Item', 300, TO_DATE('10 Oct 2025', 'DD Mon YYYY'));

-- Query to verify the trigger effect
SELECT 
    d.DONATOR_ID,
    d.FIRST_NAME,
    d.SURNAME,
    dt.TOTAL_VALUE
FROM DONATOR d
LEFT JOIN DONATOR_TOTALS dt ON d.DONATOR_ID = dt.DONATOR_ID
WHERE d.DONATOR_ID = 20113
ORDER BY d.DONATOR_ID;