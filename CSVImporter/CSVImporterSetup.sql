USE [TowedVehicles]
GO

-- CREATE STAGE TABLE
CREATE TABLE [dbo].[TowedVehiclesSTG](
	[TowDate] [date] NOT NULL,
	[Make] [nchar](4) NULL,
	[Style] [nchar](2) NULL,
	[Model] [nchar](4) NULL,
	[Color] [nchar](3) NULL,
	[Plate] [nchar](8) NULL,
	[State] [nchar](2) NULL,
	[TowedToFacility] [nvarchar](75) NULL,
	[FacilityPhone] [nchar](14) NULL,
	[ID] [int] NOT NULL
);


-- CREATE FINAL TABLE
CREATE TABLE [dbo].[TowedVehicles](
	[ID] [int] NOT NULL,
	[TowDate] [date] NOT NULL,
	[Make] [nchar](4) NULL,
	[Style] [nchar](2) NULL,
	[Model] [nchar](4) NULL,
	[Color] [nchar](3) NULL,
	[Plate] [nchar](8) NULL,
	[State] [nchar](2) NULL,
	[TowedToFacility] [nvarchar](75) NULL,
	[FacilityPhone] [nchar](14) NULL,
	CONSTRAINT PK_TowedVehicles PRIMARY KEY CLUSTERED (ID)
); 

