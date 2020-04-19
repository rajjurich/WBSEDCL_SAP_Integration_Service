select EPD_EMPID as SAP_ID,isnull(EPD_PREVIOUS_ID,'') as Legacy_ID,EPD_FIRST_NAME as Name,EOD_DESIGNATION_ID as Designation
,EOD_DEPARTMENT_ID as Department,EOD_GRADE_ID as Class,EPD_GENDER as Sex,isnull(EAD_PHONE_ONE,'') as Mobile_No,isnull(EPD_DOCTOR,'') as Place_of_posting_Org_Unit
,EOD_LOCATION_ID as Place_of_posting_Cost_Center,EOD_JOINING_DATE as Date_of_joining_at_current_office
,EOD_CONFIRM_DATE as Date_of_release_from_last_office,Hier_Mgr_ID as Controlling_officer_SAP_ID,0 as Controlling_officer_designation
,EOD_RETIREMENT_DATE as Date_of_superannuation
,'Y' as Shift_Status,'M' Shift_Day_1,'M' Shift_Day_2,'M' Shift_Day_3,'M' Shift_Day_4
,'M'Shift_Day_5,'M'Shift_Day_6,'M'Shift_Day_7,'M'Shift_Day_8,'M'Shift_Day_9,'M'Shift_Day_10
,'M'Shift_Day_11,'M'Shift_Day_12,'M'Shift_Day_13,'M'Shift_Day_14,'M'Shift_Day_15
,'M'Shift_Day_16,'M'Shift_Day_17,'M'Shift_Day_18,'M'Shift_Day_19,'M'Shift_Day_20
,'M'Shift_Day_21,'M'Shift_Day_22,'M'Shift_Day_23,'M'Shift_Day_24,'M'Shift_Day_25
,'M'Shift_Day_26,'M'Shift_Day_27,'M'Shift_Day_28,'M'Shift_Day_29,'M'Shift_Day_30,'M'Shift_Day_31
 from 
ENT_EMPLOYEE_OFFICIAL_DTLS
join 
ENT_EMPLOYEE_PERSONAL_DTLS on EPD_EMPID=EOD_EMPID
join 
ENT_EMPLOYEE_ADDRESS on EPD_EMPID=EAD_EMPID and EAD_ADDRESS_TYPE='p'
join
ENT_HierarchyDef on EPD_EMPID=Hier_Emp_ID




