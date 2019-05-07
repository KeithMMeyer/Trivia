--=========================================
DROP PROCEDURE IF EXISTS spGetVendors
CREATE PROCEDURE spGetVendors
	@pageNum INT = 0,
	@records INT = -1
AS
	SET NOCOUNT ON
    
	IF(@records = -1) BEGIN
		SELECT	VendorName, VendorCity, 
				VendorState, VendorZipCode
		FROM dbo.Vendors
		ORDER BY VendorState, VendorCity
	END ELSE BEGIN
		SELECT	VendorName, VendorCity, 
				VendorState, VendorZipCode
		FROM dbo.Vendors
		ORDER BY VendorState, VendorCity
			OFFSET (@pageNum * @records) ROWS
			FETCH NEXT @records ROWS ONLY
	END
GO

--=========================================
DROP PROCEDURE IF EXISTS spUpdateInvoicePaymentTotal
CREATE PROCEDURE spUpdateInvoicePaymentTotal
	@invoiceId int,
	@paymentTotal MONEY
AS
	UPDATE dbo.Invoices
	SET PaymentTotal = @paymentTotal
	WHERE InvoiceID = @invoiceId
GO

--=========================================
DROP PROCEDURE IF EXISTS spGetVendorDetails
CREATE PROCEDURE spGetVendorDetails
	@VendorID INT
AS
	SET NOCOUNT ON
    
	SELECT	v.VendorContactFName + ' ' + v.VendorContactLName AS VendorContact,
			[Invoices] = (
				SELECT	i.InvoiceID,
						i.InvoiceNumber,
						i.InvoiceDate,
						i.PaymentTotal,
						i.Balance
				FROM vwInvoices i
				WHERE v.VendorID = i.VendorID
				FOR JSON PATH
			)
	FROM dbo.Vendors v
	WHERE v.VendorID = @VendorID
	ORDER BY v.VendorName	
	FOR JSON PATH
GO