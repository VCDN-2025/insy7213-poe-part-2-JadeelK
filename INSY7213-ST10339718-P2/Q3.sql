-- Query 1: Update a customer's contact information
UPDATE CUSTOMER
SET CONTACT_NUMBER = '0825551234', EMAIL = 'jack.smith@newemail.com'
WHERE CUSTOMER_ID = 11011;

-- Query 2: Delete a return record
DELETE FROM RETURNS
WHERE RETURN_ID = 'ret001';

-- Query 3: List invoices with customer and donation details for deliveries after May 15, 2024
SELECT 
    c.FIRST_NAME,
    c.SURNAME,
    i.INVOICE_NUM,
    i.INVOICE_DATE,
    d.DONATION,
    dl.DELIVERY_DATE
FROM CUSTOMER c
JOIN INVOICE i ON c.CUSTOMER_ID = i.CUSTOMER_ID
JOIN DONATION d ON i.DONATION_ID = d.DONATION_ID
JOIN DELIVERY dl ON i.DELIVERY_ID = dl.DELIVERY_ID
WHERE dl.DELIVERY_DATE > TO_DATE('15 May 2024', 'DD Mon YYYY')
ORDER BY dl.DELIVERY_DATE;