let
    StartDate = Date.StartOfYear(List.Min(fact_orders[OrderDate])),
    EndDate = Date.EndOfYear(List.Max(fact_orders[OrderDate])),
    DayCount = Duration.Days(EndDate - StartDate) + 1,
    Dates = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
    AsTable = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    Typed = Table.TransformColumnTypes(AsTable, {{"Date", type date}}),
    AddYear = Table.AddColumn(Typed, "Year", each Date.Year([Date]), Int64.Type),
    AddMonthNum = Table.AddColumn(AddYear, "MonthNum", each Date.Month([Date]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonthNum, "MonthName", each Date.ToText([Date], "MMM", "en-US"), type text),
    AddMonthStart = Table.AddColumn(AddMonthName, "MonthStart", each Date.StartOfMonth([Date]), type date),
    AddYearMonth = Table.AddColumn(AddMonthStart, "YearMonth", each Date.ToText([Date], "yyyy-MM", "en-US"), type text),
    AddQuarterNum = Table.AddColumn(AddYearMonth, "QuarterNum", each Date.QuarterOfYear([Date]), Int64.Type),
    AddQuarter = Table.AddColumn(AddQuarterNum, "Quarter", each "Q" & Text.From([QuarterNum]), type text),
    AddDay = Table.AddColumn(AddQuarter, "DayOfMonth", each Date.Day([Date]), Int64.Type),
    AddWeekdayNum = Table.AddColumn(AddDay, "WeekdayNum", each Date.DayOfWeek([Date], Day.Monday) + 1, Int64.Type),
    AddWeekdayName = Table.AddColumn(AddWeekdayNum, "WeekdayName", each Date.ToText([Date], "ddd", "en-US"), type text),
    AddIsWeekend = Table.AddColumn(AddWeekdayName, "IsWeekend", each [WeekdayNum] >= 6, type logical)
in
    AddIsWeekend
