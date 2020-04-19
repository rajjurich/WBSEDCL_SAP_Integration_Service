create table CostCenterMapping
(
CostCenterMappingId int identity primary key,
Company varchar(100) not null,
HeadQuarter varchar(max) not null,
HeadQuarterCode varchar(10) not null ,
Zone varchar(max) not null,
ZoneCode varchar(10) not null,
Region varchar(max) not null,
RegionCode varchar(10) not null,
ProfitCenter varchar(max) not null,
ProfitCenterCode varchar(10) not null,
CostCenterCode varchar(10) not null,
CostCenter varchar(max) not null,
createdDate datetime,
modifiedDate datetime
)


create type CostCenterMappingData as Table
(
Company varchar(100) not null,
HeadQuarter varchar(max) not null,
HeadQuarterCode varchar(10) not null ,
Zone varchar(max) not null,
ZoneCode varchar(10) not null,
Region varchar(max) not null,
RegionCode varchar(10) not null,
ProfitCenter varchar(max) not null,
ProfitCenterCode varchar(10) not null,
CostCenterCode varchar(10) not null,
CostCenter varchar(max) not null
)

drop table CostCenterMapping