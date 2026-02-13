# =========================
# 0) Packages (install + load)
# =========================
pkgs <- c("dplyr", "ggplot2", "lubridate", "scales", "readxl", "stringr", "readr")
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install)

library(dplyr)
library(ggplot2)
library(lubridate)
library(scales)
library(readxl)
library(stringr)
library(readr)

# =========================
# 1) Data (use existing object OR read Excel)
# =========================
# Variable names used in this script:
# file_path, df, cleaned_df, status_plot, timeline_plot

file_path <- "Invoice data R project.xlsx"  # <-- put your full path here if needed

if (exists("Invoice_data_R_project")) {
  df <- Invoice_data_R_project
} else {
  if (!file.exists(file_path)) {
    stop(
      paste0(
        "File not found: ", file_path, "\n",
        "Put the Excel file in your working directory or set file_path to the full path.\n",
        "Your working directory is: ", getwd()
      )
    )
  }
  df <- readxl::read_excel(file_path)
  Invoice_data_R_project <- df
}

# =========================
# 2) Validate columns
# =========================
required_cols <- c("Invoice Amount", "Invoice Date", "Due Date", "Status")
missing_cols <- setdiff(required_cols, names(df))
if (length(missing_cols) > 0) {
  stop(paste("Missing required column(s):", paste(missing_cols, collapse = ", ")))
}

# =========================
# 3) Clean / create helper columns
# =========================
cleaned_df <- df %>%
  mutate(
    # parse_number works whether Invoice Amount is numeric or "$1,234.56"
    invoice_amount_numeric = readr::parse_number(as.character(`Invoice Amount`)),
    
    # handle Excel Dates (already Date) or character dates
    invoice_date_clean = as.Date(`Invoice Date`),
    due_date_clean     = as.Date(`Due Date`),
    
    # standardize Status text + make factor
    Status = stringr::str_trim(as.character(Status)),
    Status = stringr::str_to_title(Status),
    Status = dplyr::recode(Status,
                           "Past Due" = "Overdue",
                           "Over Due" = "Overdue"),
    Status = factor(Status, levels = c("Paid", "Pending", "Overdue"))
  )

# =========================
# 4) Plot 1: Total Invoice Amount by Status
# =========================
status_plot <- cleaned_df %>%
  filter(!is.na(Status), !is.na(invoice_amount_numeric)) %>%
  group_by(Status) %>%
  summarise(Total_Amount = sum(invoice_amount_numeric, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = Status, y = Total_Amount, fill = Status)) +
  geom_col() +
  scale_y_continuous(labels = scales::label_dollar()) +
  labs(
    title = "Total Invoice Value by Payment Status",
    x = "Status",
    y = "Total Amount (USD)"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c(
    "Paid" = "#2ecc71",
    "Pending" = "#f1c40f",
    "Overdue" = "#e74c3c"
  ), na.translate = FALSE)

print(status_plot)

# Save it so you definitely get output
ggsave("status_plot.png", plot = status_plot, width = 8, height = 5, dpi = 300)

# =========================
# 5) Plot 2: Invoices Over Time
# =========================
timeline_plot <- cleaned_df %>%
  filter(!is.na(invoice_date_clean), !is.na(invoice_amount_numeric)) %>%
  ggplot(aes(x = invoice_date_clean, y = invoice_amount_numeric)) +
  geom_point(aes(color = Status), size = 3) +
  geom_segment(aes(xend = invoice_date_clean, y = 0, yend = invoice_amount_numeric), alpha = 0.4) +
  scale_y_continuous(labels = scales::label_dollar()) +
  labs(
    title = "Invoice Issuance Timeline",
    subtitle = "Invoice amounts by date and current status",
    x = "Invoice Date",
    y = "Amount (USD)"
  ) +
  theme_minimal()

print(timeline_plot)

# Save it so you definitely get output
ggsave("timeline_plot.png", plot = timeline_plot, width = 9, height = 5, dpi = 300)

# Optional: show where the PNGs were saved
message("Saved plots to: ", getwd())


