/*
============================================================
File: 04_business_analysis.sql
Project: Predictive Maintenance & Equipment Failure Analytics

Description:
Performs business-focused analysis on machine operating
conditions and failure patterns.

Analysis includes:
- Overall failure rate
- Failure rate by machine type
- Failure rate by tool-wear group
- Failure rate by torque range
- Failure rate by rotational-speed range
- Failure-mode frequency
- Machines with multiple failure indicators

Author: Harsh Chavan
============================================================
*/


/* ============================================================
1. SELECT DATABASE
============================================================ */

USE PredictiveMaintenanceDB;
GO


/* ============================================================
2. OVERALL MACHINE FAILURE RATE
============================================================ */

SELECT
    COUNT(*) AS TotalMachines,
    SUM(CAST(MachineFailure AS INT)) AS TotalFailures,
    CAST(
        100.0 * SUM(CAST(MachineFailure AS INT)) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS FailureRate_Percent
FROM dbo.FactMachineReadings;
GO


/* ============================================================
3. FAILURE RATE BY MACHINE TYPE
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
ORDER BY FailureRate_Percent DESC;
GO


/* ============================================================
4. FAILURE RATE BY TOOL-WEAR GROUP
============================================================ */

SELECT
    CASE
        WHEN ToolWear_Min BETWEEN 0 AND 50 THEN '0-50'
        WHEN ToolWear_Min BETWEEN 51 AND 100 THEN '51-100'
        WHEN ToolWear_Min BETWEEN 101 AND 150 THEN '101-150'
        WHEN ToolWear_Min BETWEEN 151 AND 200 THEN '151-200'
        ELSE '201-253'
    END AS ToolWearGroup,

    COUNT(*) AS MachineCount,

    SUM(CAST(MachineFailure AS INT)) AS Failures,

    CAST(
        100.0 * SUM(CAST(MachineFailure AS INT)) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS FailureRate_Percent

FROM dbo.FactMachineReadings

GROUP BY
    CASE
        WHEN ToolWear_Min BETWEEN 0 AND 50 THEN '0-50'
        WHEN ToolWear_Min BETWEEN 51 AND 100 THEN '51-100'
        WHEN ToolWear_Min BETWEEN 101 AND 150 THEN '101-150'
        WHEN ToolWear_Min BETWEEN 151 AND 200 THEN '151-200'
        ELSE '201-253'
    END

ORDER BY
    MIN(ToolWear_Min);
GO


/* ============================================================
5. FAILURE RATE BY TORQUE RANGE
============================================================ */

SELECT
    CASE
        WHEN Torque_Nm < 30 THEN '<30'
        WHEN Torque_Nm BETWEEN 30 AND 40 THEN '30-40'
        WHEN Torque_Nm BETWEEN 40 AND 50 THEN '40-50'
        WHEN Torque_Nm BETWEEN 50 AND 60 THEN '50-60'
        ELSE '60+'
    END AS TorqueGroup,

    COUNT(*) AS MachineCount,

    SUM(CAST(MachineFailure AS INT)) AS Failures,

    CAST(
        100.0 * SUM(CAST(MachineFailure AS INT)) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS FailureRate_Percent

FROM dbo.FactMachineReadings

GROUP BY
    CASE
        WHEN Torque_Nm < 30 THEN '<30'
        WHEN Torque_Nm BETWEEN 30 AND 40 THEN '30-40'
        WHEN Torque_Nm BETWEEN 40 AND 50 THEN '40-50'
        WHEN Torque_Nm BETWEEN 50 AND 60 THEN '50-60'
        ELSE '60+'
    END

ORDER BY
    MIN(Torque_Nm);
GO


/* ============================================================
6. FAILURE RATE BY ROTATIONAL SPEED RANGE
============================================================ */

SELECT
    CASE
        WHEN RotationalSpeed_RPM < 1300 THEN '<1300'
        WHEN RotationalSpeed_RPM BETWEEN 1300 AND 1500 THEN '1300-1500'
        WHEN RotationalSpeed_RPM BETWEEN 1501 AND 1700 THEN '1501-1700'
        WHEN RotationalSpeed_RPM BETWEEN 1701 AND 1900 THEN '1701-1900'
        ELSE '1900+'
    END AS SpeedGroup,

    COUNT(*) AS MachineCount,

    SUM(CAST(MachineFailure AS INT)) AS Failures,

    CAST(
        100.0 * SUM(CAST(MachineFailure AS INT)) / COUNT(*)
        AS DECIMAL(6,2)
    ) AS FailureRate_Percent

FROM dbo.FactMachineReadings

GROUP BY
    CASE
        WHEN RotationalSpeed_RPM < 1300 THEN '<1300'
        WHEN RotationalSpeed_RPM BETWEEN 1300 AND 1500 THEN '1300-1500'
        WHEN RotationalSpeed_RPM BETWEEN 1501 AND 1700 THEN '1501-1700'
        WHEN RotationalSpeed_RPM BETWEEN 1701 AND 1900 THEN '1701-1900'
        ELSE '1900+'
    END

ORDER BY
    MIN(RotationalSpeed_RPM);
GO


/* ============================================================
7. FAILURE-MODE FREQUENCY
============================================================ */

SELECT
    FailureMode,
    FailureCount
FROM
(
    SELECT
        'Tool Wear Failure' AS FailureMode,
        SUM(CAST(TWF AS INT)) AS FailureCount
    FROM dbo.FactMachineReadings

    UNION ALL

    SELECT
        'Heat Dissipation Failure',
        SUM(CAST(HDF AS INT))
    FROM dbo.FactMachineReadings

    UNION ALL

    SELECT
        'Power Failure',
        SUM(CAST(PWF AS INT))
    FROM dbo.FactMachineReadings

    UNION ALL

    SELECT
        'Overstrain Failure',
        SUM(CAST(OSF AS INT))
    FROM dbo.FactMachineReadings

    UNION ALL

    SELECT
        'Random Failure',
        SUM(CAST(RNF AS INT))
    FROM dbo.FactMachineReadings
) AS FailureModes

ORDER BY FailureCount DESC;
GO


/* ============================================================
8. MACHINES WITH MULTIPLE FAILURE INDICATORS
============================================================ */

SELECT
    UDI,
    ProductID,
    MachineType,
    AirTemperature_K,
    ProcessTemperature_K,
    RotationalSpeed_RPM,
    Torque_Nm,
    ToolWear_Min,
    MachineFailure,

    (
        CAST(TWF AS INT) +
        CAST(HDF AS INT) +
        CAST(PWF AS INT) +
        CAST(OSF AS INT) +
        CAST(RNF AS INT)
    ) AS FailureIndicatorCount

FROM dbo.FactMachineReadings

WHERE
    (
        CAST(TWF AS INT) +
        CAST(HDF AS INT) +
        CAST(PWF AS INT) +
        CAST(OSF AS INT) +
        CAST(RNF AS INT)
    ) > 1

ORDER BY FailureIndicatorCount DESC, UDI;
GO