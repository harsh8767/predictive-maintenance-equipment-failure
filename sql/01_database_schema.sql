/*
============================================================
File: 01_database_schema.sql
Project: Predictive Maintenance & Equipment Failure Analytics

Description:
Creates the SQL Server analytical database structure for
the Predictive Maintenance & Equipment Failure Analytics
project.

The schema stores machine-level operational readings and
failure indicators used for exploratory analysis,
predictive modeling, and business analysis.

Table:
- FactMachineReadings

The table includes machine operating conditions, tool wear,
machine failure status, and specific failure-mode indicators.

Primary keys and constraints are used to maintain data
integrity.

Author: Harsh Chavan
============================================================
*/


/* ============================================================
1. CREATE DATABASE
============================================================ */

IF DB_ID('PredictiveMaintenanceDB') IS NULL
BEGIN
    CREATE DATABASE PredictiveMaintenanceDB;
END;
GO


/* ============================================================
2. SELECT DATABASE
============================================================ */

USE PredictiveMaintenanceDB;
GO


/* ============================================================
3. DROP EXISTING TABLE
============================================================ */

IF OBJECT_ID('dbo.FactMachineReadings', 'U') IS NOT NULL
    DROP TABLE dbo.FactMachineReadings;
GO


/* ============================================================
4. CREATE MACHINE READINGS TABLE
============================================================ */

/*
Stores machine-level operational measurements and
failure indicators used throughout the project.

UDI is used as the unique identifier for each observation.
*/

CREATE TABLE FactMachineReadings (
    UDI INT NOT NULL,

    ProductID VARCHAR(20) NOT NULL,
    MachineType CHAR(1) NOT NULL,

    AirTemperature_K DECIMAL(6,2) NOT NULL,
    ProcessTemperature_K DECIMAL(6,2) NOT NULL,

    RotationalSpeed_RPM INT NOT NULL,
    Torque_Nm DECIMAL(6,2) NOT NULL,
    ToolWear_Min INT NOT NULL,

    MachineFailure BIT NOT NULL,

    TWF BIT NOT NULL,
    HDF BIT NOT NULL,
    PWF BIT NOT NULL,
    OSF BIT NOT NULL,
    RNF BIT NOT NULL,

    CONSTRAINT PK_FactMachineReadings
        PRIMARY KEY (UDI),

    CONSTRAINT CK_FactMachineReadings_MachineType
        CHECK (MachineType IN ('L', 'M', 'H')),

    CONSTRAINT CK_FactMachineReadings_MachineFailure
        CHECK (MachineFailure IN (0, 1)),

    CONSTRAINT CK_FactMachineReadings_TWF
        CHECK (TWF IN (0, 1)),

    CONSTRAINT CK_FactMachineReadings_HDF
        CHECK (HDF IN (0, 1)),

    CONSTRAINT CK_FactMachineReadings_PWF
        CHECK (PWF IN (0, 1)),

    CONSTRAINT CK_FactMachineReadings_OSF
        CHECK (OSF IN (0, 1)),

    CONSTRAINT CK_FactMachineReadings_RNF
        CHECK (RNF IN (0, 1))
);
GO


/* ============================================================
5. VERIFY TABLE STRUCTURE
============================================================ */

/*
Displays the columns, data types, and nullability of the
machine readings table.
*/

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'FactMachineReadings'
ORDER BY ORDINAL_POSITION;
GO


/* ============================================================
6. VERIFY PRIMARY KEY
============================================================ */

/*
Displays the primary key created for the machine readings table.
*/

SELECT
    kc.name AS ConstraintName,
    OBJECT_NAME(kc.parent_object_id) AS TableName,
    COL_NAME(
        ic.object_id,
        ic.column_id
    ) AS ColumnName
FROM sys.key_constraints AS kc
JOIN sys.index_columns AS ic
    ON kc.parent_object_id = ic.object_id
    AND kc.unique_index_id = ic.index_id
WHERE kc.type = 'PK'
  AND OBJECT_NAME(kc.parent_object_id) = 'FactMachineReadings';
GO