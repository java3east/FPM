---@fpm-ignore-start
---@type Open
---@fpm-ignore-end
Open.invoice = {}

--- invoice open server functions
Open.invoice.server = {}

---Called when a new invoice has been saved in the database.
---@param invoice Invoice
function Open.invoice.server:onInvoiceCreated(invoice) end

---Called when a invoice has been payed, and updated in the database.
---@param invoice Invoice
function Open.invoice.server:onInvoicePayed(invoice) end

--- invoice open client functions
Open.invoice.client = {}

---Called when the player receives a new invoice.
---@param invoice CInvoice
function Open.invoice.client:onInvoiceReceived(invoice) end