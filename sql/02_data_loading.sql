/*
============================================================
File: 02_data_loading.sql
Project: Predictive Maintenance & Equipment Failure Analytics

Description:
Loads the predictive maintenance dataset from CSV into the
FactMachineReadings table.

The script also verifies the number of records loaded and
displays a sample of the imported data.

Author: Harsh Chavan
============================================================
*/


/* ============================================================
1. SELECT DATABASE
============================================================ */

USE PredictiveMaintenanceDB;
GO


/* ============================================================
2. LOAD DATA FROM CSV
============================================================ */

/*
IMPORTANT:
Update the file path below to the actual location of your
predictive maintenance CSV file.

SQL Server must have permission to access this file.
*/

BULK INSERT dbo.FactMachineReadings
FROM 'C:\Users\harsh\d drive\d backup\project\Predictive-Maintenance-Equipment-Failure\data\raw\ai4i2020.csv'
WITH
(
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    TABLOCK
);
GO


/* ============================================================
3. VERIFY ROW COUNT
============================================================ */

SELECT
    COUNT(*) AS TotalRecords
FROM dbo.FactMachineReadings;
GO


/* ============================================================
4. PREVIEW LOADED DATA
============================================================ */

SELECT TOP 10
    UDI,
    ProductID,
    MachineType,
    AirTemperature_K,
    ProcessTemperature_K,
    RotationalSpeed_RPM,
    Torque_Nm,
    ToolWear_Min,
    MachineFailure,
    TWF,
    HDF,
    PWF,
    OSF,
    RNF
FROM dbo.FactMachineReadings
ORDER BY UDI;
GO