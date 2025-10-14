DECLARE
    -- Variables for transaction
    v_customer_id NUMBER := 11016; -- New customer
    v_donator_id NUMBER := 20116; -- New donator
    v_donation_id NUMBER := 7118;
    v_invoice_num NUMBER := 8117;
    v_delivery_id NUMBER := 517;
    v_return_id VARCHAR2(10) := 'ret003';
    -- Exception handling
    invalid_data EXCEPTION;
    PRAGMA EXCEPTION_INIT(invalid_data, -02291);
BEGIN
    -- Start transaction
    SAVEPOINT start_transaction;

    -- Insert new customer
    INSERT INTO CUSTOMER (CUSTOMER_ID, FIRST_NAME, SURNAME, ADDRESS, CONTACT_NUMBER, EMAIL)
    VALUES (v_customer_id, 'New', 'Customer', '10 New Rd', '0811234567', 'new@customer.com');

    -- Insert new donator
    INSERT INTO DONATOR (DONATOR_ID, FIRST_NAME, SURNAME, CONTACT_NUMBER, EMAIL)
    VALUES (v_donator_id, 'New', 'Donator', '0829876543', 'new@donator.com');

    -- Insert new donation
    INSERT INTO DONATION (DONATION_ID, DONATOR_ID, DONATION, PRICE, DONATION_DATE)
    VALUES (v_donation_id, v_donator_id, 'Test Donation', 500, TO_DATE('14 Oct 2025', 'DD Mon YYYY'));

    -- Insert new invoice
    INSERT INTO INVOICE (INVOICE_NUM, CUSTOMER_ID, INVOICE_DATE, EMPLOYEE_ID, DONATION_ID, DELIVERY_ID)
    VALUES (v_invoice_num, v_customer_id, TO_DATE('14 Oct 2025', 'DD Mon YYYY'), 'emp101', v_donation_id, v_delivery_id);

    -- Insert new delivery
    INSERT INTO DELIVERY (DELIVERY_ID, DELIVERY_NOTES, DISPATCH_DATE, DELIVERY_DATE)
    VALUES (v_delivery_id, 'Test delivery', TO_DATE('14 Oct 2025', 'DD Mon YYYY'), TO_DATE('15 Oct 2025', 'DD Mon YYYY'));

    -- Insert new return (simulating a return of the new donation)
    INSERT INTO RETURNS (RETURN_ID, RETURN_DATE, REASON, CUSTOMER_ID, DONATION_ID, EMPLOYEE_ID)
    VALUES (v_return_id, TO_DATE('15 Oct 2025', 'DD Mon YYYY'), 'Test return reason', v_customer_id, v_donation_id, 'emp101');

    -- Commit transaction
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transaction completed successfully.');

EXCEPTION
    WHEN invalid_data THEN
        ROLLBACK TO start_transaction;
        DBMS_OUTPUT.PUT_LINE('Transaction rolled back due to integrity constraint violation.');
    WHEN OTHERS THEN
        ROLLBACK TO start_transaction;
        DBMS_OUTPUT.PUT_LINE('Unexpected error occurred: ' || SQLERRM);
END;
/

-- Query to generate a report of all returns with customer and donation details
SELECT 
    c.FIRST_NAME || ' ' || c.SURNAME AS CustomerName,
    d.DONATION AS DonationPurchased,
    d.PRICE AS DonationPrice,
    r.RETURN_DATE,
    r.REASON
FROM CUSTOMER c
JOIN INVOICE i ON c.CUSTOMER_ID = i.CUSTOMER_ID
JOIN DONATION d ON i.DONATION_ID = d.DONATION_ID
JOIN RETURNS r ON i.DONATION_ID = r.DONATION_ID
ORDER BY r.RETURN_DATE;