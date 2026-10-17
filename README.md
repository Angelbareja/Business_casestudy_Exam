# Regional Sales Analysis | Unlocking Revenue

A SQL-based business analysis project designed to investigate regional sales performance, completed revenue, cancelled and returned orders, product categories, sales agent performance, and customer return patterns.

**Author:** Angel Bareja  
**Project Type:** Business Case Study / Data Analytics  
**Primary Tool:** MySQL  
**Supporting Tools:** Microsoft Excel / Power BI (for optional visualization)

---

## Project Overview

Retail businesses can experience uneven sales performance across regions, cancelled orders, frequent product returns, and differences in product or sales agent performance. This project uses SQL to organize and analyze regional sales transactions, helping identify patterns and areas that may need further investigation.

The project includes a SQL script (`Exam(1).sql`) and a case study notebook (`Exam_case_study(1).ipynb`). The analysis is designed to support business decisions with summarized sales metrics rather than relying on assumptions.

> **Note:** Numerical findings and business conclusions should be added after running the queries against the actual dataset. The SQL script does not itself include the transaction data.

## Business Objectives

- Review the structure and quality of the sales dataset.
- Analyze monthly sales trends by region.
- Measure cancelled and returned order rates across regions.
- Identify regions and products with the highest value of problematic orders.
- Compare completed revenue and average order value by product category.
- Rank the top five sales agents by completed revenue.
- Calculate each category's contribution to total completed revenue.
- Identify customers with three or more returned orders.
- Summarize overall order status, realized revenue, and revenue at risk.

## Dataset Overview

The SQL table is named `RegionalSales2025` and is created inside the `RegionalSalesDB` database.

| Column | Description |
|---|---|
| `OrderID` | Unique order identifier |
| `Date` | Transaction date |
| `CustomerID` | Customer identifier |
| `Region` | Sales region |
| `ProductName` | Product name |
| `Category` | Product category |
| `Quantity` | Number of units |
| `UnitPrice` | Price per unit |
| `TotalAmount` | Total transaction amount |
| `OrderStatus` | `Completed`, `Cancelled`, or `Returned` |
| `SalesAgent` | Assigned sales agent |

The project references a source file named `RegionalSales2025.csv`. Make sure you have this dataset available before attempting to import and analyze the records.

## Tools and Technologies

- **MySQL:** Database creation, table design, data validation, aggregation, and business analysis.
- **SQL:** `SELECT`, `WHERE`, `GROUP BY`, aggregate functions, `CASE`, subqueries, date functions, and `GROUP_CONCAT`.
- **Microsoft Excel (optional):** Pivot tables and summary charts.
- **Power BI (optional):** Interactive dashboards for regional, monthly, category, and sales-agent performance.

## Analysis Included

### 1. Data Structure and Quality Checks
Creates the database and table, reviews the table structure, counts records, checks missing values, and flags records where `TotalAmount` differs from `Quantity × UnitPrice`.

### 2. Monthly and Regional Sales
Summarizes order counts, units sold, transaction value, and completed revenue by month and region.

### 3. Cancellation and Return Analysis
Calculates cancellation, return, and combined problem-order percentages for each region.

### 4. Revenue at Risk
Ranks regions and products by the value associated with cancelled or returned orders.

### 5. Product Category Performance
Compares completed revenue and average order value by category, and calculates each category's contribution to completed revenue.

### 6. Sales Agent Performance
Identifies the top five agents by completed revenue and compares cancellation and return percentages across agents.

### 7. Customer Return Patterns
Finds customers with at least three returned orders and lists their returned products.

### 8. Business Summary
Provides an overall view of order statuses, completed revenue, estimated revenue at risk, regional revenue, and top-selling products.

## How to Run the Project

1. Install and open **MySQL Workbench** or another MySQL-compatible SQL client.
2. Obtain the `RegionalSales2025.csv` dataset referenced by the case study.
3. Open `Exam(1).sql` in your SQL editor.
4. Execute the database and table creation statements.
5. Import the CSV records into `RegionalSalesDB.RegionalSales2025`, matching the CSV columns to the table schema.
6. Run the queries in sequence and review the result sets.
7. Open `Exam_case_study(1).ipynb` in Jupyter Notebook or Google Colab to review the case-study documentation.
8. Add verified findings and, if desired, create charts in Excel or Power BI.

**Important:** The SQL script creates the database and table but does not contain an `INSERT` statement or a CSV import procedure. Import the dataset before running the analysis queries; otherwise, most queries will return empty results.

## Expected Business Value

The analysis can help stakeholders investigate sales changes over time, prioritize regions or products with high cancellation and return values, understand category contribution, recognize strong sales performance, and identify repeat-return patterns.

Values associated with cancelled or returned orders are treated as **estimated revenue at risk**, not confirmed accounting losses. Actual financial impact may depend on refunds, recoveries, restocking, and accounting treatment.

## Future Improvements

- Add a repeatable CSV import and data-cleaning workflow.
- Create a Power BI dashboard with monthly and regional filters.
- Add KPI cards for completed revenue, cancellation rate, return rate, and average order value.
- Validate transaction totals and document any data-quality corrections.
- Add an executive summary with verified numerical findings after running the queries.

## Repository Files

- `Exam(1).sql` — SQL database setup, data-quality checks, and sales analysis queries.
- `Exam_case_study(1).ipynb` — Case study describing the business problem, objectives, methodology, and expected analysis.
- `RegionalSales2025.csv` — Required source dataset, referenced by the project; include it in the repository if you have permission to share it.

---

**Author: Angel Bareja**  
*Regional Sales Analysis — SQL Business Case Study*
