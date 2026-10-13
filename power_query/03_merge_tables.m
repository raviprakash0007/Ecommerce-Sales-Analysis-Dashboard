let
    Orders = fact_orders,
    JoinCust = Table.NestedJoin(Orders, {"CustomerID"}, dim_customers, {"CustomerID"}, "cust", JoinKind.LeftOuter),
    ExpCust = Table.ExpandTableColumn(JoinCust, "cust", {"CustomerName", "Segment"}),
    JoinProd = Table.NestedJoin(ExpCust, {"ProductID"}, dim_products, {"ProductID"}, "prod", JoinKind.LeftOuter),
    ExpProd = Table.ExpandTableColumn(JoinProd, "prod", {"ProductName", "Category"}),
    JoinLoc = Table.NestedJoin(ExpProd, {"LocationID"}, dim_location, {"LocationID"}, "loc", JoinKind.LeftOuter),
    ExpLoc = Table.ExpandTableColumn(JoinLoc, "loc", {"City", "State", "Region"}),
    PayAgg = Table.Group(
        fact_payments,
        {"OrderID"},
        {
            {"PaymentCount", each Table.RowCount(_), Int64.Type},
            {"PaymentModes", each Text.Combine(List.Sort(List.Distinct([PaymentMode])), " + "), type text}
        }
    ),
    JoinPay = Table.NestedJoin(ExpLoc, {"OrderID"}, PayAgg, {"OrderID"}, "pay", JoinKind.LeftOuter),
    ExpPay = Table.ExpandTableColumn(JoinPay, "pay", {"PaymentCount", "PaymentModes"}),
    AddYear = Table.AddColumn(ExpPay, "Year", each Date.Year([OrderDate]), Int64.Type),
    AddMonth = Table.AddColumn(AddYear, "Month", each Date.Month([OrderDate]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonth, "MonthName", each Date.ToText([OrderDate], "MMM", "en-US"), type text),
    AddQuarter = Table.AddColumn(AddMonthName, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([OrderDate])), type text),
    Selected = Table.SelectColumns(
        AddQuarter,
        {
            "OrderID", "OrderDate", "Year", "Month", "MonthName", "Quarter",
            "CustomerID", "CustomerName", "Segment",
            "ProductID", "ProductName", "Category",
            "Qty", "Sales", "Profit",
            "City", "State", "Region", "Status",
            "PaymentCount", "PaymentModes"
        }
    ),
    Sorted = Table.Sort(Selected, {{"OrderDate", Order.Ascending}, {"OrderID", Order.Ascending}})
in
    Sorted


let
    Paid = Table.Group(fact_payments, {"OrderID"}, {{"Paid", each List.Sum([Amount]), Int64.Type}}),
    Joined = Table.NestedJoin(fact_orders, {"OrderID"}, Paid, {"OrderID"}, "p", JoinKind.LeftOuter),
    Expanded = Table.ExpandTableColumn(Joined, "p", {"Paid"}),
    Mismatch = Table.SelectRows(Expanded, each [Paid] <> [Sales] or [Paid] = null)
in
    Mismatch
