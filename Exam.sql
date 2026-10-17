CREATE DATABASE IF NOT EXISTS RegionalSalesDB;
USE RegionalSalesDB;

CREATE TABLE IF NOT EXISTS RegionalSales2025 (
    OrderID VARCHAR(50) PRIMARY KEY,
    Date DATE NOT NULL,
    CustomerID VARCHAR(50) NOT NULL,
    Region VARCHAR(20) NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(12,2) NOT NULL,
    TotalAmount DECIMAL(14,2) NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL,
    SalesAgent VARCHAR(100) NOT NULL,

    CHECK (Quantity >= 0),
    CHECK (UnitPrice >= 0),
    CHECK (TotalAmount >= 0),
    CHECK (OrderStatus IN ('Completed', 'Cancelled', 'Returned'))
);

DESCRIBE RegionalSales2025;
SELECT COUNT(*) AS Total_Records
FROM RegionalSales2025;

SELECT *
FROM RegionalSales2025
LIMIT 10;

SELECT
    SUM(OrderID IS NULL) AS Missing_OrderID,
    SUM(Date IS NULL) AS Missing_Date,
    SUM(CustomerID IS NULL) AS Missing_CustomerID,
    SUM(Region IS NULL) AS Missing_Region,
    SUM(ProductName IS NULL) AS Missing_ProductName,
    SUM(Category IS NULL) AS Missing_Category,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(UnitPrice IS NULL) AS Missing_UnitPrice,
    SUM(TotalAmount IS NULL) AS Missing_TotalAmount,
    SUM(OrderStatus IS NULL) AS Missing_OrderStatus,
    SUM(SalesAgent IS NULL) AS Missing_SalesAgent
FROM RegionalSales2025;

SELECT *
FROM RegionalSales2025
WHERE ABS(TotalAmount - (Quantity * UnitPrice)) > 0.01;

SELECT OrderStatus, COUNT(*) AS NumberOfOrders
FROM RegionalSales2025
GROUP BY OrderStatus;

SELECT
    YEAR(Date) AS SalesYear,
    MONTH(Date) AS SalesMonth,
    DATE_FORMAT(Date, '%Y-%m') AS MonthName,
    Region,
    COUNT(*) AS TotalOrders,
    SUM(Quantity) AS TotalUnitsSold,
    SUM(TotalAmount) AS TotalTransactionValue,
    SUM(CASE
        WHEN OrderStatus = 'Completed'
        THEN TotalAmount ELSE 0
    END) AS CompletedRevenue
FROM RegionalSales2025
GROUP BY
    YEAR(Date),
    MONTH(Date),
    DATE_FORMAT(Date, '%Y-%m'),
    Region
ORDER BY SalesYear, SalesMonth, Region;

SELECT
    DATE_FORMAT(Date, '%Y-%m') AS SalesMonth,
    COUNT(*) AS TotalOrders,
    SUM(CASE
        WHEN OrderStatus = 'Completed'
        THEN TotalAmount ELSE 0
    END) AS CompletedRevenue
FROM RegionalSales2025
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY SalesMonth;

SELECT
    Region,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Cancelled'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS CancelledPercentage,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS ReturnedOrders,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Returned'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS ReturnedPercentage,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus IN ('Cancelled', 'Returned')
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS TotalProblemOrderPercentage

FROM RegionalSales2025
GROUP BY Region
ORDER BY TotalProblemOrderPercentage DESC;

SELECT
    Region,
    COUNT(*) AS ProblemOrders,
    SUM(TotalAmount) AS EstimatedRevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY Region
ORDER BY EstimatedRevenueLoss DESC
LIMIT 3;

SELECT
    ProductName,
    Category,
    COUNT(*) AS ProblemOrders,
    SUM(Quantity) AS AffectedUnits,
    SUM(TotalAmount) AS EstimatedRevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY ProductName, Category
ORDER BY EstimatedRevenueLoss DESC
LIMIT 3;

SELECT
    Category,
    COUNT(*) AS CompletedOrders,
    SUM(TotalAmount) AS CompletedRevenue,
    ROUND(AVG(TotalAmount), 2) AS AverageOrderValue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY Category
ORDER BY AverageOrderValue DESC;

SELECT
    SalesAgent,
    COUNT(*) AS CompletedOrders,
    SUM(Quantity) AS UnitsSold,
    SUM(TotalAmount) AS CompletedRevenue,
    ROUND(AVG(TotalAmount), 2) AS AverageOrderValue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY SalesAgent
ORDER BY CompletedRevenue DESC
LIMIT 5;

SELECT
    Category,
    SUM(TotalAmount) AS CategoryRevenue,

    ROUND(
        100.0 * SUM(TotalAmount) /
        NULLIF(
            (SELECT SUM(TotalAmount)
             FROM RegionalSales2025
             WHERE OrderStatus = 'Completed'),
            0
        ), 2
    ) AS ContributionPercentage

FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY Category
ORDER BY CategoryRevenue DESC;

SELECT
    CustomerID,
    COUNT(*) AS TotalReturnedOrders,
    SUM(TotalAmount) AS ReturnedOrderValue,
    GROUP_CONCAT(
        DISTINCT ProductName
        ORDER BY ProductName
        SEPARATOR ', '
    ) AS ReturnedProducts
FROM RegionalSales2025
WHERE OrderStatus = 'Returned'
GROUP BY CustomerID
HAVING COUNT(*) >= 3
ORDER BY TotalReturnedOrders DESC, ReturnedOrderValue DESC;

SELECT
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Completed'
        THEN 1 ELSE 0
    END) AS CompletedOrders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

    SUM(CASE
        WHEN OrderStatus = 'Returned'
        THEN 1 ELSE 0
    END) AS ReturnedOrders,

    SUM(CASE
        WHEN OrderStatus = 'Completed'
        THEN TotalAmount ELSE 0
    END) AS RealizedRevenue,

    SUM(CASE
        WHEN OrderStatus IN ('Cancelled', 'Returned')
        THEN TotalAmount ELSE 0
    END) AS EstimatedRevenueAtRisk

FROM RegionalSales2025;

SELECT
    Region,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Completed'
        THEN TotalAmount ELSE 0
    END) AS CompletedRevenue,

    ROUND(
        AVG(CASE
            WHEN OrderStatus = 'Completed'
            THEN TotalAmount
        END), 2
    ) AS AverageCompletedOrderValue

FROM RegionalSales2025
GROUP BY Region
ORDER BY CompletedRevenue DESC;

SELECT
    ProductName,
    Category,
    SUM(Quantity) AS UnitsSold,
    SUM(TotalAmount) AS CompletedRevenue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY ProductName, Category
ORDER BY CompletedRevenue DESC
LIMIT 10;

SELECT
    SalesAgent,
    COUNT(*) AS TotalOrders,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Cancelled'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS CancelledPercentage,

    ROUND(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Returned'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0), 2
    ) AS ReturnedPercentage

FROM RegionalSales2025
GROUP BY SalesAgent
ORDER BY ReturnedPercentage DESC;