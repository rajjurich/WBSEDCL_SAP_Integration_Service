USE [UNO_STANDARD_V2]
GO

/****** Object:  UserDefinedTableType [dbo].[SAPDATA]    Script Date: 03/04/2018 12:20:29 PM ******/
DROP TYPE [dbo].[SAPDATA]
GO

/****** Object:  UserDefinedTableType [dbo].[SAPDATA]    Script Date: 03/04/2018 12:20:30 PM ******/
CREATE TYPE [dbo].[SAPDATA] AS TABLE(
	[SAP_ID] [varchar](10) NULL,
	[Legacy_ID] [varchar](max) NULL,
	[FirstName] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[DateOfBirth] [varchar](max) NULL,
	[Pincode] [varchar](max) NULL,
	[Address1] [varchar](max) NULL,
	[Address2] [varchar](max) NULL,
	[Mobile_No] [varchar](max) NULL,
	[UnknownColumn1] [varchar](max) NULL,
	[Designation_PlaceOfPosting] [varchar](max) NULL,
	[UnknownColumn2] [varchar](max) NULL,
	[PlaceOfPosting] [varchar](max) NULL,
	[UnknownColumn3] [varchar](max) NULL,
	[Name] [varchar](max) NULL,
	[UnknownColumn4] [varchar](max) NULL,
	[Designation] [varchar](max) NULL,
	[Class] [varchar](max) NULL,
	[Sex] [varchar](max) NULL,
	[PlaceOfPostingCode] [varchar](max) NULL,
	[Date_of_joining_at_current_office] [varchar](max) NULL,
	[Date_of_release_from_last_office] [varchar](max) NULL,
	[Controlling_officer_SAP_ID] [varchar](max) NULL,
	[Controlling_officer_Name] [varchar](max) NULL,
	[Date_of_superannuation] [varchar](max) NULL,
	[Shift_Status] [varchar](max) NULL,
	[Shift_Day_1] [varchar](max) NULL,
	[Shift_Day_2] [varchar](max) NULL,
	[Shift_Day_3] [varchar](max) NULL,
	[Shift_Day_4] [varchar](max) NULL,
	[Shift_Day_5] [varchar](max) NULL,
	[Shift_Day_6] [varchar](max) NULL,
	[Shift_Day_7] [varchar](max) NULL,
	[Shift_Day_8] [varchar](max) NULL,
	[Shift_Day_9] [varchar](max) NULL,
	[Shift_Day_10] [varchar](max) NULL,
	[Shift_Day_11] [varchar](max) NULL,
	[Shift_Day_12] [varchar](max) NULL,
	[Shift_Day_13] [varchar](max) NULL,
	[Shift_Day_14] [varchar](max) NULL,
	[Shift_Day_15] [varchar](max) NULL,
	[Shift_Day_16] [varchar](max) NULL,
	[Shift_Day_17] [varchar](max) NULL,
	[Shift_Day_18] [varchar](max) NULL,
	[Shift_Day_19] [varchar](max) NULL,
	[Shift_Day_20] [varchar](max) NULL,
	[Shift_Day_21] [varchar](max) NULL,
	[Shift_Day_22] [varchar](max) NULL,
	[Shift_Day_23] [varchar](max) NULL,
	[Shift_Day_24] [varchar](max) NULL,
	[Shift_Day_25] [varchar](max) NULL,
	[Shift_Day_26] [varchar](max) NULL,
	[Shift_Day_27] [varchar](max) NULL,
	[Shift_Day_28] [varchar](max) NULL,
	[Shift_Day_29] [varchar](max) NULL,
	[Shift_Day_30] [varchar](max) NULL,
	[Shift_Day_31] [varchar](max) NULL
)
GO


