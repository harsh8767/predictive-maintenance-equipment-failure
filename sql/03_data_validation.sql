/*
============================================================
File: 03_data_validation.sql
Project: Predictive Maintenance & Equipment Failure Analytics

Description:
Performs data-quality and integrity checks on the machine
readings loaded into SQL Server.

Validation includes:
- Record count
- Duplicate UDI values
- NULL values
- Machine type distribution
- Machine failure distribution
- Failure-mode distribution
- Numeric range checks

Author: Harsh Chavan
============================================================
*/


/* ============================================================
1. SELECT DATABASE
============================================================ */

USE PredictiveMaintenanceDB;
GO


/* ============================================================
2. TOTAL RECORD COUNT
============================================================ */

SELECT
    COUNT(*) AS TotalRecords
FROM dbo.FactMachineReadings;
GO


/* ============================================================
3. CHECK FOR DUPLICATE UDI VALUES
============================================================ */

SELECT
    UDI,
    COUNT(*) AS RecordCount
FROM dbo.FactMachineReadings
GROUP BY UDI
HAVING COUNT(*) > 1;
GO


/* ============================================================
4. CHECK FOR NULL VALUES
============================================================ */

SELECT
    SUM(CASE WHEN UDI IS NULL THEN 1 ELSE 0 END) AS Null_UDI,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS Null_ProductID,
    SUM(CASE WHEN MachineType IS NULL THEN 1 ELSE 0 END) AS Null_MachineType,
    SUM(CASE WHEN AirTemperature_K IS NULL THEN 1 ELSE 0 END) AS Null_AirTemperature,
    SUM(CASE WHEN ProcessTemperature_K IS NULL THEN 1 ELSE 0 END) AS Null_ProcessTemperature,
    SUM(CASE WHEN RotationalSpeed_RPM IS NULL THEN 1 ELSE 0 END) AS Null_RotationalSpeed,
    SUM(CASE WHEN Torque_Nm IS NULL THEN 1 ELSE 0 END) AS Null_Torque,
    SUM(CASE WHEN ToolWear_Min IS NULL THEN 1 ELSE 0 END) AS Null_ToolWear,
    SUM(CASE WHEN MachineFailure IS NULL THEN 1 ELSE 0 END) AS Null_MachineFailure
FROM dbo.FactMachineReadings;
GO


/* ============================================================
5. MACHINE TYPE DISTRIBUTION
============================================================ */

SELECT
    MachineType,
    COUNT(*) AS MachineCount,
    SUM(CAST(MachineFailure AS INT)) AS Failures,
    CAST(
        100.0 * SUM(CAST(MachineFailure AS INT)) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS FailureRate_Percent
FROM dbo.FactMachineReadings
GROUP BY MachineType
ORDER BY MachineType;
GO


/* ============================================================
6. MACHINE FAILURE DISTRIBUTION
============================================================ */

SELECT
    MachineFailure,
    COUNT(*) AS RecordCount,
    CAST(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(6,2)
    ) AS Percentage
FROM dbo.FactMachineReadings
GROUP BY MachineFailure
ORDER BY MachineFailure;
GO


/* ============================================================
7. FAILURE-MODE DISTRIBUTION
============================================================ */

SELECT
    SUM(CAST(TWF AS INT)) AS ToolWearFailures,
    SUM(CAST(HDF AS INT)) AS HeatDissipationFailures,
    SUM(CAST(PWF AS INT)) AS PowerFailures,
    SUM(CAST(OSF AS INT)) AS OverstrainFailures,
    SUM(CAST(RNF AS INT)) AS RandomFailures
FROM dbo.FactMachineReadings;
GO


/* ============================================================
8. NUMERIC RANGE VALIDATION
============================================================ */

SELECT
    MIN(AirTemperature_K) AS MinAirTemperature,
    MAX(AirTemperature_K) AS MaxAirTemperature,

    MIN(ProcessTemperature_K) AS MinProcessTemperature,
    MAX(ProcessTemperature_K) AS MaxProcessTemperature,

    MIN(RotationalSpeed_RPM) AS MinRotationalSpeed,
    MAX(RotationalSpeed_RPM) AS MaxRotationalSpeed,

    MIN(Torque_Nm) AS MinTorque,
    MAX(Torque_Nm) AS MaxTorque,

    MIN(ToolWear_Min) AS MinToolWear,
    MAX(ToolWear_Min) AS MaxToolWear
FROM dbo.FactMachineReadings;
GO


/* ============================================================
9. INVALID MACHINE TYPE CHECK
============================================================ */

SELECT *
FROM dbo.FactMachineReadings
WHERE MachineType NOT IN ('L', 'M', 'H');
GO


/* ============================================================
10. INVALID FAILURE FLAG CHECK
============================================================ */

SELECT *
FROM dbo.FactMachineReadings
WHERE MachineFailure NOT IN (0, 1);
GO