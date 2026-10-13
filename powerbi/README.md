# Power BI project (PBIP)

`Ecommerce_Sales_Dashboard.pbip` is a Power BI Project: a text-based version of the dashboard.

## Open it
1. Install Power BI Desktop (Windows), latest version.
2. File > Options > Preview features: make sure *Power BI Project (.pbip) save option* is on (already on by default in recent versions). Restart if asked.
3. Double-click `Ecommerce_Sales_Dashboard.pbip`.
4. Click **Home > Refresh**. The data is embedded in the model, so nothing else is needed.
5. **File > Save as** and choose `.pbix` to get `Ecommerce_Sales_Dashboard.pbix`.

## What is inside
- `Ecommerce_Sales_Dashboard.SemanticModel/`: 6 tables, 5 relationships, 109 DAX measures, 30 calculated columns.
- `Ecommerce_Sales_Dashboard.Report/`: 9 pages (Cover + 8 dashboard pages), about 190 visuals, theme, background images and icons.
- `theme/dark_blue_theme.json`: same theme that the report uses.

The data is a compressed copy of `data/raw/*.csv` inside each table's Power Query step. To read the CSV files instead, use the scripts in `power_query/` (01 to 04).

## If something does not open
Visuals are generated from code. Anything Power BI cannot read is shown as an error icon on that visual only; rebuild it by dragging the same fields. Send the error text to get it fixed.

## Look and layout

Each page background (sidebar, panels, KPI tiles, titles, legends) is a PNG in `assets/backgrounds/bg_*.png`. Charts, cards, tables and slicers are transparent Power BI visuals placed on top. Do not move visuals off their panels. Donut legends and the small labels under donut totals are part of the background image.

## Near real-time data in Power BI Desktop / Service

- Replace the CSV path (`DataFolder`) with a database, SharePoint or Excel-on-OneDrive source that your orders system writes to.
- In Power BI Service, set **Scheduled refresh** (Pro: up to 8 times a day) on the semantic model.
- For second-by-second updates use a DirectQuery source with **Automatic page refresh** (Report settings, Page refresh) or a streaming dataset.
