USE [UNO_STANDARD_V2]
GO
/****** Object:  StoredProcedure [dbo].[uspProcessSAPIntegrationData]    Script Date: 08/05/2018 12:05:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[uspProcessSAPIntegrationData]
as


set nocount on
BEGIN TRAN;

BEGIN TRY
CREATE TABLE #LocationChangeCheckTable  
    ( ActionTaken nvarchar(10), 
	EmpId varchar(10),
	NewLocation varchar(50),
	OldLocation varchar(50)	
    ); 

	CREATE TABLE #NewLocationTable  
    ( ActionTaken nvarchar(10), 
	EmpId varchar(10),
	NewLocation varchar(50)
    ); 

	Create TABLE #EmployeesForShiftCreation
	(
	EmpId varchar(10)
	)

---------------------------------------------------
MERGE ENT_EMPLOYEE_PERSONAL_DTLS AS T  
USING (SELECT SAP_ID,Legacy_ID,FirstName,LastName,DateOfBirth,Sex FROM SAPIntegrationData where Flag=0) AS S (SAP_ID,Legacy_ID,FirstName,LastName,DateOfBirth,Sex)  
ON (T.EPD_EMPID = S.SAP_ID)  
WHEN MATCHED
	THEN UPDATE SET T.EPD_FIRST_NAME=S.FirstName,T.EPD_LAST_NAME=S.LastName,T.EPD_PREVIOUS_ID=S.Legacy_ID,T.EPD_GENDER=S.Sex,T.EPD_DOB=S.DateOfBirth
WHEN NOT MATCHED By TARGET
    THEN INSERT (EPD_EMPID, EPD_FIRST_NAME,EPD_LAST_NAME,EPD_PREVIOUS_ID,EPD_GENDER,EPD_DOB,EPD_ISDELETED,EPD_CARD_ID) VALUES (S.SAP_ID, S.FirstName,S.LastName,S.Legacy_ID,S.Sex,S.DateOfBirth,0,S.SAP_ID)  
 
OUTPUT $action, Inserted.*, Deleted.*;  
PRINT 'Personal details'
---------------------------------------------------
MERGE ENT_ORG_COMMON_ENTITIES As T
USING(SELECT distinct Designation FROM SAPIntegrationData where Flag=0) AS S(Designation)
ON(T.OCE_ID=(select dbo.GetDesignationCode(S.Designation)) AND T.CEM_ENTITY_ID='DES')
WHEN NOT MATCHED BY TARGET
	THEN INSERT(CEM_ENTITY_ID,OCE_ID,OCE_DESCRIPTION,OCE_ISDELETED,COMPANY_ID) VALUES('DES',(select dbo.GetDesignationCode(S.Designation)),S.Designation,0,1)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Designation'
---------------------------------------------------
MERGE ENT_EMPLOYEE_OFFICIAL_DTLS AS T  
USING (SELECT SAP_ID,PlaceOfPostingCode FROM SAPIntegrationData where Flag=0) AS S (SAP_ID,PlaceOfPostingCode)  
ON (T.EOD_EMPID = S.SAP_ID)  
WHEN MATCHED
	THEN UPDATE SET T.EOD_LOCATION_ID=S.PlaceOfPostingCode	

OUTPUT $action,Inserted.EOD_EMPID, Inserted.EOD_LOCATION_ID,Deleted.EOD_LOCATION_ID INTO #LocationChangeCheckTable;  



--update eal_config set FLAG=2,ISDELETED=1,DELETEDDATE=getdate() 
--from (select * from #LocationChangeCheckTable tbl 
--join acs_controller acs
--on tbl.OldLocation = acs.CTLR_LOCATION_ID) tbl2
-- where EMPLOYEE_CODE = tbl2.EmpId
-- and CONTROLLER_ID= tbl2.CTLR_ID
---------------------------------------------------
MERGE ENT_EMPLOYEE_OFFICIAL_DTLS AS T  
USING (SELECT SAP_ID,Designation,Class,PlaceOfPostingCode,Date_of_joining_at_current_office,Date_of_release_from_last_office,Date_of_superannuation FROM SAPIntegrationData where Flag=0) AS S (SAP_ID,Designation,Class,PlaceOfPostingCode,Date_of_joining_at_current_office,Date_of_release_from_last_office,Date_of_superannuation)  
ON (T.EOD_EMPID = S.SAP_ID)  
WHEN MATCHED
	THEN UPDATE SET T.EOD_DESIGNATION_ID=(select dbo.GetDesignationCode(S.Designation)),T.EOD_DEPARTMENT_ID=S.PlaceOfPostingCode, T.EOD_GRADE_ID=S.Class
	,T.EOD_JOINING_DATE=S.Date_of_joining_at_current_office,T.EOD_CONFIRM_DATE=S.Date_of_release_from_last_office,T.EOD_RETIREMENT_DATE=case when S.Date_of_superannuation = '0000-00-00' then null else S.Date_of_superannuation end
WHEN NOT MATCHED By TARGET
    THEN INSERT (EOD_EMPID, EOD_DESIGNATION_ID,EOD_DEPARTMENT_ID,EOD_GRADE_ID,EOD_LOCATION_ID,EOD_JOINING_DATE,EOD_CONFIRM_DATE,EOD_RETIREMENT_DATE,EOD_ACTIVE,EOD_COMPANY_ID,EOD_ISDELETED,EOD_DIVISION_ID,EOD_CATEGORY_ID,EOD_GROUP_ID,EOD_STATUS,EOD_TYPE) VALUES 
	(S.SAP_ID,(select dbo.GetDesignationCode(S.Designation)),S.PlaceOfPostingCode,S.Class,S.PlaceOfPostingCode,S.Date_of_joining_at_current_office,S.Date_of_release_from_last_office,case when S.Date_of_superannuation = '0000-00-00' then null else S.Date_of_superannuation end,case when S.Date_of_superannuation = '0000-00-00' or S.Date_of_superannuation >= cast(getdate() as date) then 1 else 0 end,1,0,'DIV','CAT','GRP','C','E')  

--OUTPUT $action, Inserted.*, Deleted.*;  
OUTPUT $action,Inserted.EOD_EMPID, Inserted.EOD_LOCATION_ID INTO #NewLocationTable; 
PRINT 'Official details'

---------------------------------------------------
MERGE ENT_EMPLOYEE_LEFT As T
USING(SELECT distinct SAP_ID,Date_of_superannuation FROM SAPIntegrationData where (Date_of_superannuation <> '0000-00-00' and cast(case when Date_of_superannuation = '0000-00-00' then null else Date_of_superannuation end as date)<= cast(getdate()-1 as date))) AS S(SAP_ID,Date_of_superannuation)
ON(T.EL_EMP_ID = S.SAP_ID ) 
WHEN NOT MATCHED BY TARGET
	THEN INSERT(EL_EMP_ID,EL_LEFT_DATE) VALUES(S.SAP_ID,S.Date_of_superannuation)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Employee Left'
---------------------------------------------------
MERGE ENT_EMPLOYEE_OFFICIAL_DTLS As T
USING(SELECT distinct SAP_ID,Date_of_superannuation FROM SAPIntegrationData where (Date_of_superannuation <> '0000-00-00' and cast(case when Date_of_superannuation = '0000-00-00' then null else Date_of_superannuation end as date) <= cast(getdate()-1 as date))) AS S(SAP_ID,Date_of_superannuation)
ON(T.EOD_EMPID = S.SAP_ID) and T.EOD_ACTIVE=1
WHEN MATCHED
	THEN UPDATE SET T.EOD_ACTIVE=0,T.EOD_RETIREMENT_DATE=S.Date_of_superannuation
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Employee InActive'
---------------------------------------------------
MERGE ENT_ORG_COMMON_ENTITIES As T
USING(SELECT distinct Class FROM SAPIntegrationData where Flag=0) AS S(Class)
ON(T.OCE_ID=S.Class AND T.CEM_ENTITY_ID='GRD')
WHEN NOT MATCHED BY TARGET
	THEN INSERT(CEM_ENTITY_ID,OCE_ID,OCE_DESCRIPTION,OCE_ISDELETED,COMPANY_ID) VALUES('GRD',S.Class,S.Class,0,1)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Class'
---------------------------------------------------
MERGE ENT_ORG_COMMON_ENTITIES As T
USING(SELECT distinct PlaceOfPostingCode FROM SAPIntegrationData where Flag=0) AS S(PlaceOfPostingCode)
ON(T.OCE_ID=S.PlaceOfPostingCode AND T.CEM_ENTITY_ID='LOC')
WHEN NOT MATCHED BY TARGET
	THEN INSERT(CEM_ENTITY_ID,OCE_ID,OCE_DESCRIPTION,OCE_ISDELETED,COMPANY_ID) VALUES('LOC',S.PlaceOfPostingCode,S.PlaceOfPostingCode,0,1)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Location'
---------------------------------------------------
MERGE ENT_ORG_COMMON_ENTITIES As T
USING(SELECT distinct PlaceOfPostingCode FROM SAPIntegrationData where Flag=0) AS S(PlaceOfPostingCode)
ON(T.OCE_ID=S.PlaceOfPostingCode AND T.CEM_ENTITY_ID='DEP')
WHEN NOT MATCHED BY TARGET
	THEN INSERT(CEM_ENTITY_ID,OCE_ID,OCE_DESCRIPTION,OCE_ISDELETED,COMPANY_ID) VALUES('DEP',S.PlaceOfPostingCode,S.PlaceOfPostingCode,0,1)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Department'
----------------------------------------------------
MERGE ENT_HierarchyDef As T
USING(SELECT SAP_ID,Controlling_officer_SAP_ID FROM SAPIntegrationData where Flag=0 and Controlling_officer_SAP_ID<>'00000000') AS S(SAP_ID,Controlling_officer_SAP_ID)
ON(T.Hier_Emp_ID=S.SAP_ID)
WHEN MATCHED
	THEN UPDATE SET T.Hier_Mgr_ID=S.Controlling_officer_SAP_ID
WHEN NOT MATCHED BY TARGET
	THEN INSERT(Hier_Emp_ID,Hier_Mgr_ID) VALUES(S.SAP_ID,S.Controlling_officer_SAP_ID)
OUTPUT $action, Inserted.*, Deleted.*;
PRINT 'Controlling Officer' 
----------------------------------------------------
MERGE ENT_EMPLOYEE_ADDRESS As T
USING(SELECT SAP_ID,Pincode,Mobile_No,Address1 + Address2 as fulladdress FROM SAPIntegrationData where Flag=0) AS S(SAP_ID,Pincode,Mobile_No,fulladdress)
ON(T.EAD_EMPID=S.SAP_ID)
WHEN MATCHED
	THEN UPDATE SET T.EAD_PIN=S.Pincode,T.EAD_PHONE_ONE=S.Mobile_No,T.EAD_ADDRESS=S.fulladdress
WHEN NOT MATCHED BY TARGET
	THEN INSERT(EAD_EMPID,EAD_ADDRESS_TYPE,EAD_ADDRESS,EAD_PIN,EAD_PHONE_ONE) VALUES(S.SAP_ID,'P',S.fulladdress,S.Pincode,S.Mobile_No)
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'Employee address'

------------------------------------------------------

--MERGE EAL_CONFIG As T
--USING(SELECT SAP_ID,Date_of_superannuation,CTLR_ID FROM SAPIntegrationData join ACS_CONTROLLER on PlaceOfPostingCode = CTLR_LOCATION_ID where Flag=0 and (Date_of_superannuation = '0000-00-00' or cast(case when Date_of_superannuation = '0000-00-00' then null else Date_of_superannuation end as date)> cast(getdate()-1 as date))) AS S(SAP_ID,Date_of_superannuation,CTLR_ID)
--ON(T.EMPLOYEE_CODE=S.SAP_ID and T.CONTROLLER_ID=S.CTLR_ID and T.ISDELETED=0)
--WHEN NOT MATCHED BY TARGET
--	THEN INSERT(ENTITY_TYPE,[ENTITY_ID],EMPLOYEE_CODE,CARD_CODE,AL_ID,FLAG,CONTROLLER_ID) VALUES('EMP',S.SAP_ID,S.SAP_ID,S.SAP_ID,'',0,S.CTLR_ID)
----WHEN NOT MATCHED BY SOURCE
----	THEN UPDATE SET T.FLAG=2,T.ISDELETED=1,T.DELETEDDATE=getdate()
--OUTPUT $action, Inserted.*, Deleted.*; 
--PRINT 'EAL Config Add'

------------------------------------------------------

MERGE EAL_CONFIG As T
USING(SELECT SAP_ID,Date_of_superannuation FROM SAPIntegrationData where (Date_of_superannuation <> '0000-00-00' and cast(case when Date_of_superannuation = '0000-00-00' then null else Date_of_superannuation end as date)<= cast(getdate()-1 as date))) AS S(SAP_ID,Date_of_superannuation)
ON(T.EMPLOYEE_CODE=S.SAP_ID) and T.ISDELETED=0
WHEN MATCHED
	THEN UPDATE SET T.FLAG=2,T.ISDELETED=1,T.DELETEDDATE=getdate()
OUTPUT $action, Inserted.*, Deleted.*; 
PRINT 'EAL Config Delete'

------------------------------------------------------

MERGE TNA_EMPLOYEE_TA_CONFIG As T
USING(select SAP_ID from SAPIntegrationData where Flag=0 and (Date_of_superannuation = '0000-00-00' or cast(case when Date_of_superannuation = '0000-00-00' then null else Date_of_superannuation end as date)> cast(getdate()-1 as date))) AS S(epd_empid)
ON(T.ETC_EMP_ID=S.epd_empid) and T.ETC_ISDELETED=0
WHEN NOT MATCHED by TARGET
	THEN INSERT(ETC_EMP_ID,ETC_MINIMUM_SWIPE,ETC_SHIFTCODE,ETC_WEEKEND,ETC_WEEKOFF,ETC_SHIFT_START_DATE,ETC_ISDELETED,ScheduleType,ShiftType) values (S.epd_empid,2,'G',(select top 1 mwk_cd from dbo.TA_WKLYOFF where MWK_OFF=1),(select top 1 mwk_cd from dbo.TA_WKLYOFF where MWK_OFF=0),getdate(),0,'fixed','G')
OUTPUT Inserted.ETC_EMP_ID into #EmployeesForShiftCreation; 
SELECT * FROM #EmployeesForShiftCreation
PRINT 'TNA Employee Config'

------------------------------------------------------

update SAPIntegrationData set flag=1,ProcessedDate=getdate() where flag=0

COMMIT TRAN;

print 'commit'
select * from #LocationChangeCheckTable where NewLocation<>OldLocation

select * into #EalCheckTable from (
select *,(select top 1 al_id from eal_config eal where eal.[ENTITY_ID]=loc.OldLocation and ISDELETED=0) as oldAlId,
(select top 1 al_id from eal_config eal where eal.[ENTITY_ID]=loc.NewLocation and ISDELETED=0) as newAlId from #LocationChangeCheckTable loc
where NewLocation<>OldLocation
) a
select * from #EalCheckTable
declare @old_al_id varchar(50)
declare @new_al_id varchar(50)
declare @old_location varchar(50)
declare @new_location varchar(50)
declare @EmpID varchar(10)
select * from #EalCheckTable
WHILE EXISTS (SELECT 1 FROM #EalCheckTable)
BEGIN

    SELECT TOP 1 @EmpID=EmpId,@old_al_id = oldAlId,@new_al_id=newAlId,@old_location=OldLocation,@new_location=NewLocation FROM #EalCheckTable
	if(@old_al_id=@new_al_id and @old_al_id is not null)
	begin
		print 'do nothing'
	end
	else
	begin
		if(@old_al_id is not null)
		begin
			Update Eal_config set FLAG=2,ISDELETED=1,DELETEDDATE=getdate() where EMPLOYEE_CODE=@EmpID and [ENTITY_ID]=@old_location
		end
		if(@new_al_id is not null)
		begin
			insert into Eal_config([ENTITY_ID],CONTROLLER_ID,ENTITY_TYPE,EMPLOYEE_CODE,CARD_CODE,AL_ID,FLAG,ISDELETED)
			select distinct [ENTITY_ID],CONTROLLER_ID,'LOC',@EmpID,@EmpID,@new_al_id,0,0 from eal_config where al_id=@new_al_id	and ISDELETED=0		 
		end
	end
    

    DELETE FROM #EalCheckTable WHERE EmpId = @EmpID
END

PRINT 'Location Change check'


select * from #NewLocationTable

select * into #EalTable from (
select *,
(select top 1 al_id from eal_config eal where eal.[ENTITY_ID]=loc.NewLocation and ISDELETED=0) as newAlId from #NewLocationTable loc
) a

select * from #EalTable
WHILE EXISTS (SELECT 1 FROM #EalTable)
BEGIN
	SELECT TOP 1 @EmpID=EmpId,@new_al_id=newAlId,@new_location=NewLocation FROM #EalTable
	insert into Eal_config([ENTITY_ID],CONTROLLER_ID,ENTITY_TYPE,EMPLOYEE_CODE,CARD_CODE,AL_ID,FLAG,ISDELETED)
	select distinct [ENTITY_ID],CONTROLLER_ID,'LOC',@EmpID,@EmpID,@new_al_id,0,0 from eal_config where al_id=@new_al_id	and ISDELETED=0		 

	DELETE FROM #EalTable WHERE EmpId = @EmpID
	print @EmpID
END
PRINT 'EAL Config Add'



print 'Shift Creation'
declare @month int
declare @year int
set @month = month(getdate())
set @year = year(getdate())

--declare @EmpID varchar(10)
WHILE EXISTS (SELECT 1 FROM #EmployeesForShiftCreation)
BEGIN

    SELECT TOP 1 @EmpID = EmpId FROM #EmployeesForShiftCreation

    EXEC ShiftScheduleCreator @month,@year,@EmpID

    DELETE FROM #EmployeesForShiftCreation WHERE EmpId = @EmpID
END
print 'Shift Creation Completed'

Select 1
END TRY

BEGIN CATCH
SELECT 
	ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;
ROLLBACK TRAN;
END CATCH
