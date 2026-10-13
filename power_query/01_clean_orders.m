let
    Source = Csv.Document(
        File.Contents(DataFolder & "orders.csv"),
        [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Promoted,
        {
            {"OrderID", type text}, {"OrderDate", type date}, {"CustomerID", type text},
            {"ProductID", type text}, {"LocationID", type text}, {"Qty", Int64.Type},
            {"Sales", Int64.Type}, {"Profit", Int64.Type}, {"Status", type text}
        },
        "en-US"
    ),
    Trimmed = Table.TransformColumns(
        Typed,
        {
            {"OrderID", each Text.Upper(Text.Trim(_)), type text},
            {"CustomerID", each Text.Upper(Text.Trim(_)), type text},
            {"ProductID", each Text.Upper(Text.Trim(_)), type text},
            {"LocationID", each Text.Upper(Text.Trim(_)), type text},
            {"Status", each Text.Proper(Text.Trim(_)), type text}
        }
    ),
    NoDuplicates = Table.Distinct(Trimmed, {"OrderID"}),
    NoMissingKeys = Table.SelectRows(
        NoDuplicates,
        each [OrderID] <> null and [OrderID] <> ""
            and [OrderDate] <> null and [CustomerID] <> null
            and [ProductID] <> null and [LocationID] <> null
    ),
    FilledProfit = Table.ReplaceValue(NoMissingKeys, null, 0, Replacer.ReplaceValue, {"Profit"}),
    FilledQty = Table.ReplaceValue(FilledProfit, null, 1, Replacer.ReplaceValue, {"Qty"}),
    ValidRows = Table.SelectRows(
        FilledQty,
        each [Sales] <> null and [Sales] > 0 and [Qty] > 0
            and List.Contains({"Delivered", "Shipped", "Cancelled"}, [Status])
    ),
    Sorted = Table.Sort(ValidRows, {{"OrderDate", Order.Ascending}, {"OrderID", Order.Ascending}})
in
    Sorted


let
    Source = Csv.Document(
        File.Contents(DataFolder & "payments.csv"),
        [Delimiter = ",", Columns = 4, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Promoted,
        {{"TransactionID", type text}, {"OrderID", type text}, {"PaymentMode", type text}, {"Amount", Int64.Type}},
        "en-US"
    ),
    Normalised = Table.TransformColumns(
        Typed,
        {
            {"TransactionID", each Text.Upper(Text.Trim(_)), type text},
            {"OrderID", each Text.Upper(Text.Trim(_)), type text},
            {
                "PaymentMode",
                each
                    let m = Text.Upper(Text.Trim(_))
                    in
                        if m = "UPI" then "UPI"
                        else if m = "EMI" then "EMI"
                        else if m = "CARD" or m = "CARDS" then "Cards"
                        else if m = "CASH" then "Cash"
                        else m,
                type text
            }
        }
    ),
    NoDuplicates = Table.Distinct(Normalised, {"TransactionID"}),
    NoMissing = Table.SelectRows(
        NoDuplicates,
        each [TransactionID] <> null and [OrderID] <> null and [PaymentMode] <> null
            and [Amount] <> null and [Amount] > 0
    ),
    Joined = Table.NestedJoin(NoMissing, {"OrderID"}, fact_orders, {"OrderID"}, "ord", JoinKind.Inner),
    Clean = Table.RemoveColumns(Joined, {"ord"})
in
    Clean
