"""Run each SQL file, print results, and save the key charts to reports/figures."""
from pathlib import Path

import duckdb
import matplotlib.pyplot as plt
import seaborn as sns

ROOT = Path(__file__).resolve().parents[1]
FIG = ROOT / "reports" / "figures"
FIG.mkdir(parents=True, exist_ok=True)
con = duckdb.connect(str(ROOT / "data" / "olist.duckdb"), read_only=True)
sns.set_theme(style="whitegrid")


def q(name):
    """Run every SELECT statement in a SQL file and return a list of DataFrames."""
    sql = (ROOT / "sql" / name).read_text()
    return [con.execute(s).df() for s in sql.split(";") if "SELECT" in s.upper()]


def save(name):
    plt.tight_layout()
    plt.savefig(FIG / name, dpi=150)
    plt.close()


# 1. KPIs + funnel
for df in q("01_kpis_and_funnel.sql"):
    print(df, "\n")

# 2. Cohort retention heatmap (first 12 months)
coh = q("02_cohort_retention.sql")[0]
pivot = coh.pivot(index="cohort_month", columns="month_number", values="active_customers")
pivot = pivot[pivot[0] >= 100]  # drop tiny cohorts (e.g. 2016-12 has 1 customer)
ret = pivot.div(pivot[0], axis=0).iloc[:, :12] * 100
ret.index = ret.index.strftime("%Y-%m")
plt.figure(figsize=(12, 8))
sns.heatmap(ret.iloc[:, 1:], annot=True, fmt=".1f", cmap="Blues", vmin=0, vmax=1,
            cbar_kws={"label": "% retained"})
plt.title("Monthly cohort retention (%)")
save("cohort_retention.png")

# 3. RFM segments
rfm = q("03_rfm_segmentation.sql")[0]
print(rfm, "\n")
rfm.plot.barh(x="segment", y="revenue", legend=False, figsize=(8, 5), title="Revenue by RFM segment")
save("rfm_revenue.png")

# 4. Delivery timeliness vs review score
dv = q("04_delivery_vs_reviews.sql")[0]
print(dv, "\n")
ax = dv.plot.bar(x="delivery_bucket", y="avg_review", legend=False, figsize=(8, 5), rot=0,
                 title="Average review score by delivery timeliness")
ax.set_ylim(1, 5)
save("delivery_vs_reviews.png")

# 5. Categories and regions
cat, region = q("05_category_region.sql")
print(cat, "\n")
print(region.head(10), "\n")
cat.plot.barh(x="category", y="revenue", legend=False, figsize=(8, 6),
              title="Top 15 categories by revenue").invert_yaxis()
save("top_categories.png")

print(f"Charts saved to {FIG}")
