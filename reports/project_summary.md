# Project Summary: Olist E-commerce Retention Analysis
*A 2-minute read*

## The question
Olist (a Brazilian marketplace) grew to **R$15.4M revenue and 93k customers**. **Why don't customers come back, and what should the business do about it?**

## What I did
| Step | Tools | Output |
|---|---|---|
| Loaded 9 related tables (~100k orders) | Python, DuckDB | A reproducible database |
| Wrote 5 analyses | SQL (CTEs, window functions, cohorts) | Funnel, retention, RFM segments, delivery vs reviews, category and region revenue |
| Visualised the findings | pandas, matplotlib, seaborn | Charts in `reports/figures/` |
| Built an executive dashboard | Power BI (star schema, DAX) | [3-page PDF](../dashboard/olist_dashboard.pdf) |

## 3 key findings
1. **Retention is the real problem.** Only **3%** of customers ever buy again, and month-1 retention is under 1%. Revenue growth was driven entirely by new customers.
2. **Late delivery damages satisfaction.** On-time orders average **4.2★**. Orders 7+ days late average **1.7★**, with about **80% negative reviews**.
3. **The delays are regional.** **24%** of orders in Alagoas arrive late, compared with an 8% average. The North-East states have the worst late-delivery rates.

## Recommendations
| Action | Metric | Estimated impact |
|---|---|---|
| Fix the delivery promise in North-East states | Late-delivery % | Fewer 1★ reviews on ~6k late orders |
| Second-purchase coupon (A/B tested, ~5.3k users per group) | 90-day repeat rate | 3% → 5% ≈ +R$300k |
| Win-back campaign for 13.8k high-value lapsed customers | Reactivation rate | ≈ +R$110k at a 5% response |

## Decisions worth noting
- **Counted customers by `customer_unique_id`, not `customer_id`.** Olist issues a new ID per order, so the naive count would hide the retention problem entirely.
- **Bucketed delivery delay instead of averaging it.** This exposed a threshold: satisfaction collapses once an order is late, not gradually.
- **Excluded tiny cohorts** (e.g. a 1-customer month) that distorted the retention heatmap.
- **Checked every number in a dashboard title against the SQL.**

## Limitations
This is a public 2016–2018 sample. The impact figures are directional estimates. Reviews are linked to orders, not to individual items.
