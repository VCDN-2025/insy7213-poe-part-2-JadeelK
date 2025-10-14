-- Query 1: List all customers with their invoice details
SELECT 
    c.CUSTOMER_ID,
    c.FIRST_NAME,
    c.SURNAME,
    i.INVOICE_NUM,
    i.INVOICE_DATE,
    d.DONATION
FROM CUSTOMER c
JOIN INVOICE i ON c.CUSTOMER_ID = i.CUSTOMER_ID
JOIN DONATION d ON i.DONATION_ID = d.DONATION_ID
ORDER BY c.CUSTOMER_ID;

-- Query 2: List employees and the returns they handled
SELECT 
    e.EMPLOYEE_ID,
    e.FIRST_NAME,
    e.SURNAME,
    r.RETURN_ID,
    r.RETURN_DATE,
    r.REASON
FROM EMPLOYEE e
JOIN RETURNS r ON e.EMPLOYEE_ID = r.EMPLOYEE_ID
ORDER BY e.EMPLOYEE_ID;

-- Query 3: Calculate total donation value per donator
SELECT 
    d.DONATOR_ID,
    d.FIRST_NAME,
    d.SURNAME,
    SUM(do.PRICE) AS TOTAL_DONATION_VALUE
FROM DONATOR d
JOIN DONATION do ON d.DONATOR_ID = do.DONATOR_ID
GROUP BY d.DONATOR_ID, d.FIRST_NAME, d.SURNAME
ORDER BY d.DONATOR_ID;