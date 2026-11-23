# Dashboard: Design Rationale

📊 **[olist_dashboard.pdf](olist_dashboard.pdf)**: a 3-page Power BI report built on the SQL analysis in this repo.

This file explains *why* the dashboard looks the way it does. Every page, chart and metric was chosen to answer one business question: **why don't Olist customers come back, and what should we do about it?**

---

## Why Power BI
- **It's the most widely used BI tool** in enterprise, consulting and business-analyst roles, so the dashboard matches the tool most stakeholders already use.
- **The star-schema model** (orders and order items as facts; customers, products and dates as dimensions) keeps the DAX measures simple and fast. It also lets every filter (year, region) flow correctly through all the visuals.
- **The heavy lifting is done in SQL** (cleaning, RFM scoring, delivery buckets). Power BI only aggregates and presents, so the logic is version-controlled and reproducible.

## Why three pages: a story, not a data dump
The pages follow the order an executive would ask questions in:

| Page | Question it answers | Why it's there |
|---|---|---|
| **1. Executive Overview** | *How is the business doing?* | Sets the context: R$15.4M revenue and strong growth, but a 3% repeat rate. The growth hides a retention problem. |
| **2. Delivery & Satisfaction** | *Why aren't customers happy enough to return?* | The root cause: late deliveries send reviews from 4.2★ to 1.7★, and the delays concentrate in the North-East. |
| **3. Customers & Retention** | *Who should we target, and what should we do?* | Turns the insight into action: segments to win back, plus three recommendations. |

Each page moves from **what** → **why** → **so what**, which mirrors the findings and recommendations in the [main README](../README.md).

## Why these metrics
| Metric | Why it was chosen over alternatives |
|---|---|
| **Revenue (delivered orders only)** | Cancelled or undelivered orders aren't real revenue, and counting them would overstate performance. |
| **Customers (`customer_unique_id`)** | Olist issues a new `customer_id` per order. Counting those would make every customer look new and hide the retention problem. |
| **Repeat Customer %** | The headline health metric for a marketplace. Revenue growth alone can mask a business that has to buy every order with new acquisition spend. |
| **Late Delivery % and delivery buckets** | Bucketing (early / on-time / 1–7 days late / 7+ days late) shows a *threshold* effect that a simple average would blur. |
| **Negative Review % (1–2★)** | Averages hide extremes. "79% negative" is more actionable and more memorable than "1.7★". |
| **RFM segments** | A standard, explainable segmentation that maps directly to marketing actions (win-back, loyalty, nurture). It doesn't need a black-box model. |
| **Revenue MoM %** | Shows momentum. With no month selected it defaults to the latest full month, so the card is never misleading. |

## Why these chart types
- **KPI cards on top:** a reader gets the headline numbers in 5 seconds before reading any chart.
- **Line chart for revenue:** the trend over time is the point. It's limited to Jan 2017–Aug 2018 because the months before and after are near-empty and would distort the picture.
- **Sorted horizontal bars** for categories and states: the long labels stay readable and the ranking is instantly visible.
- **Combo chart** (Avg Review and Negative %) by delivery bucket: two scales in one view show *both* the drop in average and the spike in unhappy customers.
- **Scatter chart** (delivery days vs review score per state): tests the hypothesis visually. Slower states sit lower.
- **Table for segments:** exact numbers matter when deciding where to spend a marketing budget.
- **No pie charts or 3D visuals:** they make comparisons harder.

## Design choices
- **Titles state the insight, not the topic.** "Late deliveries drive 1★ reviews" instead of "Delivery Analysis", so a reader gets the message even without studying the chart.
- **Every number in a title was checked** against the underlying SQL.
- **Few filters (year, region):** enough to explore without letting a reader get lost.
- **Recommendations live in the dashboard itself**, so it ends in a decision rather than just a description.

## Limitations
- The data is a public sample (2016–2018). The impact figures in the recommendations are directional estimates, not forecasts.
- Reviews are linked to orders, not to individual items, so a bad review can't be traced to a single product in a multi-item order.
