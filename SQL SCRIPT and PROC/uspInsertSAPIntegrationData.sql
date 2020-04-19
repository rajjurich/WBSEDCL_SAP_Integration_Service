USE [UNO_STANDARD_V2]
GO
/****** Object:  StoredProcedure [dbo].[uspInsertSAPIntegrationData]    Script Date: 08/05/2018 2:14:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER proc [dbo].[uspInsertSAPIntegrationData]
(
@DetailsTable SAPDATA Readonly
)
As

set nocount on
BEGIN TRAN;

BEGIN TRY

create table #EmpTable
(
EmpId varchar(10)
)


--TRUNCATE TABLE SAPCompanyDataTempTable
--INSERT INTO SAPCompanyDataTempTable(companyId,companyName) 
--            SELECT companyId,companyName FROM @DetailsTable 
 
MERGE SAPIntegrationData as T
USING @DetailsTable as S
ON (T.SAP_ID='00'+S.SAP_ID AND T.Legacy_ID=S.Legacy_ID AND T.FirstName=S.FirstName AND T.LastName=S.LastName AND T.DateOfBirth=S.DateOfBirth
AND T.Pincode=S.Pincode AND T.Address1=S.Address1 AND T.Address2=S.Address2 AND T.Mobile_No=S.Mobile_No
AND T.UnknownColumn1= S.UnknownColumn1 AND T.Designation_PlaceOfPosting=S.Designation_PlaceOfPosting
AND T.UnknownColumn2=S.UnknownColumn2 AND T.PlaceOfPosting=S.PlaceOfPosting
AND T.UnknownColumn3=S.UnknownColumn3 AND T.Name=S.Name
AND T.UnknownColumn4=S.UnknownColumn4 AND T.Designation=S.Designation
AND T.Class=S.Class AND T.Sex=S.Sex AND T.PlaceOfPostingCode=S.PlaceOfPostingCode 
AND T.Date_of_joining_at_current_office=S.Date_of_joining_at_current_office AND T.Date_of_release_from_last_office=S.Date_of_release_from_last_office 
AND T.Controlling_officer_SAP_ID=S.Controlling_officer_SAP_ID AND T.Controlling_officer_Name=S.Controlling_officer_Name
AND T.Date_of_superannuation=S.Date_of_superannuation
AND T.Shift_Status=S.Shift_Status
AND T.Shift_Day_1=S.Shift_Day_1 AND T.Shift_Day_2=S.Shift_Day_2 AND T.Shift_Day_3=S.Shift_Day_3 AND T.Shift_Day_4=S.Shift_Day_4 AND T.Shift_Day_5=S.Shift_Day_5
AND T.Shift_Day_6=S.Shift_Day_6 AND T.Shift_Day_7=S.Shift_Day_7 AND T.Shift_Day_8=S.Shift_Day_8 AND T.Shift_Day_9=S.Shift_Day_9 AND T.Shift_Day_10=S.Shift_Day_10
AND T.Shift_Day_11=S.Shift_Day_11 AND T.Shift_Day_12=S.Shift_Day_12 AND T.Shift_Day_13=S.Shift_Day_13 AND T.Shift_Day_14=S.Shift_Day_14 AND T.Shift_Day_15=S.Shift_Day_15
AND T.Shift_Day_16=S.Shift_Day_16 AND T.Shift_Day_17=S.Shift_Day_17 AND T.Shift_Day_18=S.Shift_Day_18 AND T.Shift_Day_19=S.Shift_Day_19 AND T.Shift_Day_20=S.Shift_Day_20
AND T.Shift_Day_21=S.Shift_Day_21 AND T.Shift_Day_22=S.Shift_Day_22 AND T.Shift_Day_23=S.Shift_Day_23 AND T.Shift_Day_24=S.Shift_Day_24 AND T.Shift_Day_25=S.Shift_Day_25
AND T.Shift_Day_26=S.Shift_Day_26 AND T.Shift_Day_27=S.Shift_Day_27 AND T.Shift_Day_28=S.Shift_Day_28 AND T.Shift_Day_29=S.Shift_Day_29 AND T.Shift_Day_30=S.Shift_Day_30 AND T.Shift_Day_31=S.Shift_Day_31
)
WHEN NOT MATCHED BY TARGET
	THEN INSERT(SAP_ID,Legacy_ID,FirstName,LastName,DateOfBirth,Pincode,Address1,Address2,Mobile_No,UnknownColumn1,Designation_PlaceOfPosting,
UnknownColumn2,PlaceOfPosting,UnknownColumn3,Name,UnknownColumn4,Designation,Class,Sex,PlaceOfPostingCode,
Date_of_joining_at_current_office,Date_of_release_from_last_office,Controlling_officer_SAP_ID,Controlling_officer_Name,Date_of_superannuation,Shift_Status,Shift_Day_1,Shift_Day_2,Shift_Day_3,Shift_Day_4,Shift_Day_5,
Shift_Day_6,Shift_Day_7,Shift_Day_8,Shift_Day_9,Shift_Day_10,Shift_Day_11,Shift_Day_12,Shift_Day_13,Shift_Day_14,Shift_Day_15,
Shift_Day_16,Shift_Day_17,Shift_Day_18,Shift_Day_19,Shift_Day_20,Shift_Day_21,Shift_Day_22,Shift_Day_23,Shift_Day_24,Shift_Day_25,
Shift_Day_26,Shift_Day_27,Shift_Day_28,Shift_Day_29,Shift_Day_30,Shift_Day_31,Flag,CreatedDate) VALUES
('00'+S.SAP_ID,S.Legacy_ID,S.FirstName,S.LastName,S.DateOfBirth,S.Pincode,S.Address1,S.Address2,S.Mobile_No,S.UnknownColumn1,S.Designation_PlaceOfPosting,S.
UnknownColumn2,S.PlaceOfPosting,S.UnknownColumn3,S.Name,S.UnknownColumn4,S.Designation,S.Class,S.Sex,S.PlaceOfPostingCode,S.Date_of_joining_at_current_office,S.Date_of_release_from_last_office,S.Controlling_officer_SAP_ID,S.Controlling_officer_Name,S.Date_of_superannuation,
S.Shift_Status,S.Shift_Day_1,S.Shift_Day_2,S.Shift_Day_3,S.Shift_Day_4,S.Shift_Day_5,
S.Shift_Day_6,S.Shift_Day_7,S.Shift_Day_8,S.Shift_Day_9,S.Shift_Day_10,
S.Shift_Day_11,S.Shift_Day_12,S.Shift_Day_13,S.Shift_Day_14,S.Shift_Day_15,
S.Shift_Day_16,S.Shift_Day_17,S.Shift_Day_18,S.Shift_Day_19,S.Shift_Day_20,
S.Shift_Day_21,S.Shift_Day_22,S.Shift_Day_23,S.Shift_Day_24,S.Shift_Day_25,
S.Shift_Day_26,S.Shift_Day_27,S.Shift_Day_28,S.Shift_Day_29,S.Shift_Day_30,S.Shift_Day_31,0,getdate())
--WHEN MATCHED
--	THEN UPDATE SET T.Name=S.Name

OUTPUT Inserted.SAP_ID into #EmpTable;

insert into SAPIntegrationDataHistory
select '00'+SAP_ID,Legacy_ID,FirstName,LastName,DateOfBirth,Pincode,Address1,Address2,Mobile_No,UnknownColumn1,Designation_PlaceOfPosting,
UnknownColumn2,PlaceOfPosting,UnknownColumn3,Name,UnknownColumn4,Designation,Class,Sex,PlaceOfPostingCode,
Date_of_joining_at_current_office,Date_of_release_from_last_office,Controlling_officer_SAP_ID,Controlling_officer_Name,Date_of_superannuation,Shift_Status,Shift_Day_1,Shift_Day_2,Shift_Day_3,Shift_Day_4,Shift_Day_5,
Shift_Day_6,Shift_Day_7,Shift_Day_8,Shift_Day_9,Shift_Day_10,Shift_Day_11,Shift_Day_12,Shift_Day_13,Shift_Day_14,Shift_Day_15,
Shift_Day_16,Shift_Day_17,Shift_Day_18,Shift_Day_19,Shift_Day_20,Shift_Day_21,Shift_Day_22,Shift_Day_23,Shift_Day_24,Shift_Day_25,
Shift_Day_26,Shift_Day_27,Shift_Day_28,Shift_Day_29,Shift_Day_30,Shift_Day_31,0,getdate(),null from @DetailsTable

delete from SAPIntegrationData where SAP_ID in (select EmpId from #EmpTable) and Flag=1

COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN;
SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;  
END CATCH



















