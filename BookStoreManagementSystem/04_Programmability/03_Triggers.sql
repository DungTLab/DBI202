-- Trigger: Prevent deleting a customer if they have related orders.
-- Type: INSTEAD OF DELETE (intercepts the delete attempt and applies custom logic).
CREATE TRIGGER trg_Prevent_Delete_Customer
ON CUSTOMER
INSTEAD OF DELETE
AS
BEGIN
    -- Check whether any customer in the DELETE set appears in ORDERS.
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN ORDERS o ON d.customer_id = o.customer_id
    )
    BEGIN
        -- Block the operation with a business-rule error.
        RAISERROR ('Cannot delete customer with existing orders.', 16, 1);
        RETURN;
    END

    -- If no related orders exist, proceed with deleting the target customer rows.
    DELETE FROM CUSTOMER
    WHERE customer_id IN (SELECT customer_id FROM deleted);
END;
