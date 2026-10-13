# Data Dictionary

E-Commerce Sales Analysis Dashboard (Power BI, DAX, Power Query, Excel).
Period: **01 Jan 2024 - 31 Dec 2024**. All data is **synthetic sample data** (not real customers or transactions).

## Dataset at a glance

| Item | Value |
|---|---|
| Orders | 532 |
| Customers | 487 |
| Payment transactions | 1,563 |
| Products | 40 (3 categories) |
| Locations | 26 cities in 17 states (4 regions) |
| Total sales | ₹42,78,560 |
| Total profit | ₹8,56,320 (20.0% margin) |

---

## Raw files (`data/raw/`)

### orders.csv (fact table, 1 row = 1 order, 1 product per order)

| Column | Type | Description |
|---|---|---|
| OrderID | Text (PK) | Unique order number, `ORD0001` to `ORD0532`, in date order |
| OrderDate | Date | Order date, `yyyy-mm-dd` |
| CustomerID | Text (FK) | Links to `customers.CustomerID` |
| ProductID | Text (FK) | Links to `products.ProductID` |
| LocationID | Text (FK) | Links to `locations.LocationID` (customer's delivery city) |
| Qty | Integer | Units ordered |
| Sales | Integer (₹) | Net order value in rupees. Equals the sum of that order's payments |
| Profit | Integer (₹) | Profit on the order in rupees |
| Status | Text | `Delivered`, `Shipped` or `Cancelled` |

### customers.csv (dimension)

| Column | Type | Description |
|---|---|---|
| CustomerID | Text (PK) | `C0001` to `C0487`, numbered by first order date |
| CustomerName | Text | Customer name (sample) |
| Segment | Text | `New`, `Returning` or `VIP` |

**Segment** is a CRM-style tag, not calculated from the 2024 orders: *New* = first-time buyer, *Returning* = bought before, *VIP* = loyalty tier. Counts: 282 New, 156 Returning, 49 VIP.

### products.csv (dimension)

| Column | Type | Description |
|---|---|---|
| ProductID | Text (PK) | `P001` to `P040` |
| ProductName | Text | Product name |
| Category | Text | `Electronics`, `Furniture` or `Clothing` |
| UnitPrice | Integer (₹) | Average selling price = total sales / total units for that product |

### locations.csv (dimension)

| Column | Type | Description |
|---|---|---|
| LocationID | Text (PK) | `L01` to `L26` |
| City | Text | City |
| State | Text | State / UT (Delhi counted as a state) |
| Region | Text | `West`, `North`, `South` or `East` |

### payments.csv (fact table, 1 row = 1 payment transaction)

| Column | Type | Description |
|---|---|---|
| TransactionID | Text (PK) | `TXN00001` to `TXN01563` |
| OrderID | Text (FK) | Links to `orders.OrderID` |
| PaymentMode | Text | `UPI`, `EMI`, `Cards` or `Cash` |
| Amount | Integer (₹) | Amount paid in this transaction |

An order can be settled by several transactions (split payment, instalments, partial cash). For every order, the sum of its transaction amounts equals `orders.Sales`.

---

## Processed file (`data/processed/ecommerce_sales_clean.xlsx`)

Output of the Power Query step: all raw tables merged into analysis-ready sheets.

| Sheet | Contents |
|---|---|
| KPI_Summary | Headline KPIs and breakdowns by category, quarter, region, status, segment, state and payment mode. Every number is a formula over the two data sheets |
| Orders_Clean | One row per order with customer, product and location details joined |
| Payments_Clean | One row per transaction with order date, category and state added |

Extra columns in `Orders_Clean`:

| Column | Description |
|---|---|
| Year, Month, MonthName, Quarter | Derived from OrderDate (`Q1` to `Q4`) |
| CustomerName, Segment | From customers |
| ProductName, Category | From products |
| City, State, Region | From locations |
| PaymentCount | Number of payment transactions for the order |
| PaymentModes | Modes used, e.g. `Cards + UPI` |

Extra columns in `Payments_Clean`: OrderDate, Category, State.

---

## Data model (see `data_model.png`)

| From (many) | To (one) | Cardinality |
|---|---|---|
| fact_orders[CustomerID] | dim_customers[CustomerID] | Many-to-one |
| fact_orders[ProductID] | dim_products[ProductID] | Many-to-one |
| fact_orders[LocationID] | dim_location[LocationID] | Many-to-one |
| fact_orders[OrderDate] | dim_date[Date] | Many-to-one |
| fact_payments[OrderID] | fact_orders[OrderID] | Many-to-one |

`dim_date` is built in Power Query or DAX (see `dax/calculated_columns.dax`): Date, Year, MonthNum, MonthName, MonthStart, QuarterNum, Quarter.

## Business rules

- **Cancelled orders are included** in Total Sales, Profit and Orders, as in the dashboard (423 Delivered + 74 Shipped + 35 Cancelled = 532). To exclude them, filter `Status <> "Cancelled"`.
- **Profit margin %** = Total Profit / Total Sales.
- **Average order value** = Total Sales / Total Orders.
- **Total customers** = distinct customers with at least one order.
- All amounts are in Indian rupees (₹).
- No missing values and no duplicate IDs in any raw file.

## Sample-data notes

- The data was generated to reproduce the headline numbers of the dashboard design (totals, category and state sales, payment-mode split, top customers and products). Values for other cells are random but consistent.
- Because the dashboard mock-up's own numbers are not fully consistent (for example its city chart), city-wise charts built from this data will rank cities differently from the mock-up image.
- Unit prices are small compared with real prices (for example iPhone 15 ≈ ₹8,867) because they were back-calculated from the mock-up's sales and quantity figures.
