# Business Insights & Recommendations

Page 8 of the dashboard. All figures come from the sample dataset in `data/` (01 Jan - 31 Dec 2024, 532 orders, ₹42,78,560 sales).

## Headline numbers

| Metric | Value |
|---|---|
| Total sales | ₹42,78,560 |
| Total profit | ₹8,56,320 (20.0% margin) |
| Orders / customers | 532 / 487 |
| Average order value | ₹8,042 |
| Payment transactions | 1,563 (average ₹2,737) |

## Key insights

1. **Electronics is the top category.** It brings ₹17,97,400, which is **42.0%** of sales, followed by Furniture (32.9%) and Clothing (25.1%).
2. **Electronics also earns the best margin** at **22.8%**, against 18.6% for Furniture and 17.2% for Clothing.
3. **Maharashtra leads the states** with ₹8,45,210 (**19.8%** of sales). Uttar Pradesh (14.8%) and Karnataka (9.8%) follow, and the top 5 states together make **60.6%** of sales.
4. **West and North regions carry half the business**: West 32%, North 28%, South 22%, East 18%.
5. **UPI is the most used payment mode**: **45%** of the amount paid and 46% of transactions. EMI is 22% of the amount, Cards 18%, Cash 15%.
6. **Q4 is the strongest quarter**: ₹12,52,506 sales, which is 29% of the year and **49% higher than Q1** (₹8,41,683). Q4 also has the best margin (21.3%). December is the best month and January the weakest.
7. **A small group of customers matters.** The top 10 customers contribute **16.7%** of revenue, and the 49 VIP customers (10% of customers) contribute **25.8%**.
8. **Order fulfilment is healthy but not perfect**: 79.5% delivered, 13.9% still shipped, **6.6% cancelled** (₹2.9 lakh of sales, 6.8%).
9. **Sales are concentrated in few products**: the top 10 of 40 products make 48.5% of sales. iPhone 15 is the top product by both sales (₹4,25,600) and profit (₹1,12,450).
10. **Electronics orders are the biggest tickets**: average order ₹10,330 against ₹9,782 for Furniture and ₹5,012 for Clothing. Furniture buyers use EMI the most (27% of amount).

## Recommendations

| # | Recommendation | Why (from the data) |
|---|---|---|
| 1 | Increase marketing spend on **Electronics**, with targeted campaigns | Largest share (42%) and highest margin (22.8%) |
| 2 | Expand in **Maharashtra, Uttar Pradesh and Karnataka**, and test smaller states such as Telangana and Kerala | Top 3 states give 44% of sales; Telangana and Kerala are each below 2.2% |
| 3 | Promote **UPI offers** (cashback, instant discount) | UPI already carries 45% of the amount paid, so offers reach the most customers |
| 4 | Offer **EMI plans on Furniture and big Electronics** | EMI is 27% of Furniture payments and 21% of Electronics |
| 5 | Plan **inventory and staffing for Q4** (festive and year-end sales) | Q4 is 29% of sales with the best margin |
| 6 | Launch a **loyalty programme** for repeat and VIP buyers | VIP customers give 25.8% of revenue from 10% of customers |
| 7 | **Reduce cancellations** (confirmation calls, COD verification) | 6.6% of orders cancelled, ₹2.9 lakh of sales |
| 8 | Reduce dependence on a few products by **bundling and cross-selling** | Top 10 products make 48.5% of sales |

## Notes

- Sample data: use these as a template and re-check every number after loading your own data. The dashboard's DAX measures (`dax/measures.dax`, section 9) produce the same insight sentences dynamically.
- The mock-up image shows "Top 10 customers contribute 28%" and "Furniture has the highest profit margin"; the sample data gives 16.7% and Electronics instead, so the text above follows the data.
