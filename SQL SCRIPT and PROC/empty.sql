update SAPIntegrationData set flag=0,ProcessedDate=null

truncate table ENT_EMPLOYEE_OFFICIAL_DTLS

truncate table ENT_EMPLOYEE_PERSONAL_DTLS

truncate table ENT_EMPLOYEE_ADDRESS

truncate table ENT_HierarchyDef

truncate table ENT_ORG_COMMON_ENTITIES


truncate table ENT_EMPLOYEE_LEFT

truncate table  EAL_CONFIG

truncate table  TNA_EMPLOYEE_TA_CONFIG
truncate table  tday

truncate table SAPIntegrationData


truncate table tasc


truncate table  ACS_Events
select * from SAPIntegrationData 
select * from 
--delete
 ENT_EMPLOYEE_OFFICIAL_DTLS where eod_empid like '9%'

select * from 
--delete
 ENT_EMPLOYEE_PERSONAL_DTLS where epd_empid like '9%'
select * from 
--delete
  ENT_EMPLOYEE_ADDRESS where EAD_EMPID like '9%'
select * from 
--delete
   ENT_HierarchyDef where Hier_Emp_ID like '9%'

select * from 
--delete
  ENT_ORG_COMMON_ENTITIES where company_id is null or company_id='1'

  select * from 
  --delete
  ENT_EMPLOYEE_LEFT where EL_EMP_ID like '9%'
  select * from 
  --delete
  EAL_CONFIG where employee_code like '9%'

select * from
  --delete 
   TNA_EMPLOYEE_TA_CONFIG where ETC_EMP_ID like '9%'

select * from 
   --delete 
   tday where tday_empcde like '9%'
  update SAPIntegrationData set flag=0,ProcessedDate=null

sp_tables '%org%'