# RStudio AR Project (Invoice Status & Timeline)

A small **Accounts Receivable (AR)** mini‑project in **R** that reads invoice data from Excel, cleans the fields, and generates two quick visualizations:

1) **Total Invoice Value by Payment Status** (`status_plot.png`)  
2) **Invoice Issuance Timeline** (`timeline_plot.png`)

This is useful for a fast AR “health check” (how much is Paid vs Pending vs Overdue, and what invoice activity looks like over time).

---

## What this project does

- Loads invoice data from an Excel file (`Invoice data R project.xlsx`)
- Validates the required columns exist
- Cleans common formatting issues:
  - Converts `"Invoice Amount"` to a numeric value (works even if values look like `$1,234.56`)
  - Converts `"Invoice Date"` and `"Due Date"` into proper `Date` values
  - Standardizes `Status` text (trim + Title Case) and maps common variants like `"Past Due"` → `"Overdue"`
- Creates and saves two plots as PNG files in the project folder

---

## Input data format

Your Excel file should include these columns **exactly** (case‑sensitive as written):

| Column | Meaning | Example |
|---|---|---|
| `Customer Name` | Customer / account name | `Horizon Venture` |
| `Invoice Date` | Date invoice was issued | `2026-01-02` |
| `Due Date` | Date invoice is due | `2026-02-01` |
| `Status` | Payment status | `Paid`, `Pending`, `Overdue` |
| `Invoice Amount` | Invoice value | `1550.00` or `$1,550.00` |

**Status values expected:** `Paid`, `Pending`, `Overdue`  
The script also recodes `"Past Due"` and `"Over Due"` to `Overdue`.

---

## Quick start (RStudio)

1. Clone / download this repo.
2. Open the project folder in **RStudio**.
3. Make sure the Excel file is in the project folder (or edit the path).
4. Run the script:

Open `Rstudio-AR-Project.R` and click **Source** (or run line‑by‑line).

✅ Outputs saved:
- `status_plot.png`
- `timeline_plot.png`

---

## Run from the command line (optional)

If you have R installed, you can run:

```bash
Rscript Rstudio-AR-Project.R
```

---

## Packages used

The script installs missing packages automatically, then loads:

- `dplyr`
- `ggplot2`
- `lubridate`
- `scales`
- `readxl`
- `stringr`
- `readr`

---

## Project structure (suggested)

```text
.
├── Rstudio-AR-Project.R
├── Invoice data R project.xlsx        # optional to keep in repo; see note below
├── status_plot.png                    # generated output
└── timeline_plot.png                  # generated output
```

---

## Notes on GitHub (important)

If you plan to use **real** invoice data, it’s better to **not** push it to GitHub.

You can ignore Excel files by adding this to a `.gitignore`:

```text
*.xlsx
*.csv
data/
```

Then keep your data locally in a `data/` folder.

---

## Customization ideas

Easy upgrades you can add next:
- AR aging buckets (e.g., 0–30, 31–60, 61–90, 90+ days) based on `Due Date`
- A monthly trend chart (sum of invoice amounts per month)
- Customer‑level totals (top 10 customers by outstanding value)
- Export a clean CSV after cleaning (`cleaned_df`) for reporting

---

