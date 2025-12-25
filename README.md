# Small Business Sales Analytics

## Overview
This project demonstrates an end-to-end sales analytics workflow using SQL for data modeling and Microsoft Power BI for data visualization.

The goal of the project is to analyze small business sales performance, including revenue trends, product performance, and customer lifetime value.

## Tech Stack
- Microsoft SQL Server
- Microsoft Power BI

## Database Design
The database includes a normalized sales schema with the following tables:
- Customers
- Products
- Orders
- OrderItems

Primary and foreign key constraints are used to enforce data integrity.

## Data Generation
The database is populated with realistic mock data including:
- 100+ customers
- 10 products
- 500+ orders with multiple order items

Set-based SQL techniques are used to efficiently generate transactional data.

## Analytics & Reporting
SQL views are created to support analytics and reporting:
- Order totals
- Monthly revenue trends
- Product-level performance
- Customer lifetime value

[SmallBusinessSales.pdf](https://github.com/user-attachments/files/24340967/SmallBusinessSales.pdf)

## Power BI Dashboard
The Power BI dashboard visualizes:
- Revenue trends over time
- Revenue by product
- Order-level details
- Customer lifetime value
