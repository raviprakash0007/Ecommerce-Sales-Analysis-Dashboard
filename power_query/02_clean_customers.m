let
    Source = Csv.Document(
        File.Contents(DataFolder & "customers.csv"),
        [Delimiter = ",", Columns = 3, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Promoted,
        {{"CustomerID", type text}, {"CustomerName", type text}, {"Segment", type text}},
        "en-US"
    ),
    Cleaned = Table.TransformColumns(
        Typed,
        {
            {"CustomerID", each Text.Upper(Text.Trim(_)), type text},
            {"CustomerName", each Text.Proper(Text.Trim(_)), type text},
            {
                "Segment",
                each
                    let s = Text.Upper(Text.Trim(_))
                    in if s = "VIP" then "VIP" else Text.Proper(s),
                type text
            }
        }
    ),
    FilledSegment = Table.ReplaceValue(
        Cleaned,
        null,
        "New",
        Replacer.ReplaceValue,
        {"Segment"}
    ),
    NoMissing = Table.SelectRows(FilledSegment, each [CustomerID] <> null and [CustomerID] <> ""),
    NoDuplicates = Table.Distinct(NoMissing, {"CustomerID"}),
    Sorted = Table.Sort(NoDuplicates, {{"CustomerID", Order.Ascending}})
in
    Sorted


let
    Source = Csv.Document(
        File.Contents(DataFolder & "products.csv"),
        [Delimiter = ",", Columns = 4, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Promoted,
        {{"ProductID", type text}, {"ProductName", type text}, {"Category", type text}, {"UnitPrice", Int64.Type}},
        "en-US"
    ),
    Cleaned = Table.TransformColumns(
        Typed,
        {
            {"ProductID", each Text.Upper(Text.Trim(_)), type text},
            {"ProductName", each Text.Trim(_), type text},
            {"Category", each Text.Proper(Text.Trim(_)), type text}
        }
    ),
    NoMissing = Table.SelectRows(Cleaned, each [ProductID] <> null and [ProductID] <> "" and [Category] <> null),
    NoDuplicates = Table.Distinct(NoMissing, {"ProductID"}),
    Sorted = Table.Sort(NoDuplicates, {{"ProductID", Order.Ascending}})
in
    Sorted


let
    Source = Csv.Document(
        File.Contents(DataFolder & "locations.csv"),
        [Delimiter = ",", Columns = 4, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Promoted,
        {{"LocationID", type text}, {"City", type text}, {"State", type text}, {"Region", type text}},
        "en-US"
    ),
    Cleaned = Table.TransformColumns(
        Typed,
        {
            {"LocationID", each Text.Upper(Text.Trim(_)), type text},
            {"City", each Text.Proper(Text.Trim(_)), type text},
            {"State", each Text.Proper(Text.Trim(_)), type text},
            {"Region", each Text.Proper(Text.Trim(_)), type text}
        }
    ),
    NoMissing = Table.SelectRows(Cleaned, each [LocationID] <> null and [LocationID] <> "" and [State] <> null),
    NoDuplicates = Table.Distinct(NoMissing, {"LocationID"}),
    Sorted = Table.Sort(NoDuplicates, {{"LocationID", Order.Ascending}})
in
    Sorted
