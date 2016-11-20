
  CREATE OR REPLACE FORCE VIEW TERRITORYUSERHIERARCHY ("REPORTLEVEL", "TERRITORYNAME", "REGIONNAME", "TANAME", "USERNAME", "USERID", "TERRITORYBEGINDATE", "TERRITORYENDDATE", "SUPERVISORUSERID") AS 
  (
(select ur.relationship_type as ReportLevel,
optl.optValue as TerritoryName,
optl_region.optValue as RegionName,
optl_ta.optValue as TAName,
ut.lastname||', '||ut.firstname as UserName,
ut.id as userId,
ur.begin_date as territoryBeginDate,
ur.end_date as territoryEndDate,
ur.related_user_id as SupervisorUserID
from user_table ut
inner join user_relationship ur
on (ur.user_id = ut.id)
inner join option_lookup optl
on (optl.id = ur.territory)
inner join user_table ut_regionLevel
on (ut_regionLevel.id = ur.related_user_id)
inner join user_relationship ur_region
on (ur_region.user_id = ut_regionLevel.id)
inner join option_lookup optl_region
on (optl_region.id = ur_region.territory)
inner join user_table ut_taLevel
on (ut_taLevel.id = ur_region.related_user_id)
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_taLevel.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut.deleteflag = 'N'
and ut_regionLevel.deleteflag = 'N'
and ut_taLevel.deleteflag = 'N'
and ur.relationship_type = 1
and ur_region.relationship_type = 2
and ur_ta.relationship_type = 3
and ur.begin_date <= sysdate
and ur.end_date >= sysdate
and ur_region.begin_date <= sysdate
and ur_region.end_date >= sysdate
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate)
union
(select ur_region.relationship_type as ReportLevel,
'' as TerritoryName,
optl_region.optValue as RegionName,
optl_ta.optValue as TAName,
ut_regionLevel.lastname||', '||ut_regionLevel.firstname as UserName,
ut_regionLevel.id as userId,
ur_region.begin_date as territoryBeginDate,
ur_region.end_date as territoryEndDate,
ur_region.related_user_id as SupervisorUserID
from user_table ut_regionLevel
inner join user_relationship ur_region
on (ur_region.user_id = ut_regionLevel.id)
inner join option_lookup optl_region
on (optl_region.id = ur_region.territory)
inner join user_table ut_taLevel
on (ut_taLevel.id = ur_region.related_user_id)
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_taLevel.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut_regionLevel.deleteflag = 'N'
and ut_taLevel.deleteflag = 'N'
and ur_region.relationship_type = 2
and ur_ta.relationship_type = 3
and ur_region.begin_date <= sysdate
and ur_region.end_date >= sysdate
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate
)
union
(select ur_ta.relationship_type as ReportLevel,
'' as TerritoryName,
'' as RegionName,
optl_ta.optValue as TAName,
ut_ta.lastname||', '||ut_ta.firstname as UserName,
ut_ta.id as userId,
ur_ta.begin_date as territoryStartDate,
ur_ta.end_date as territoryEndDate,
ur_ta.related_user_id as SupervisorUserID
from user_table ut_ta
inner join user_relationship ur_ta
on (ur_ta.user_id = ut_ta.id)
inner join option_lookup optl_ta
on (optl_ta.id = ur_ta.territory)
where ut_ta.deleteflag = 'N'
and ur_ta.relationship_type in (3,4)
and ur_ta.begin_date <= sysdate
and ur_ta.end_date >= sysdate
));
.
/
 
 
 
create or replace function getUserRelationshipCount(userId number, reportLevel number)
return number is totalCount number;
begin
totalCount:=0;
declare
  countLevel1 number;
  countLevel2 number;
  countLevel3 number;
  countLevel4 number;


begin
	countLevel1:=0;
	countLevel2:=0;
	countLevel3:=0;
    countLevel4:=0;

	if reportLevel =2 then
		select count(distinct(urv.user_id)) into countLevel2 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ut.id=userId)) urv;
	end if;

	if reportLevel =3 then
		select count(distinct(urv.user_id)) into countLevel2 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ut.id=userId)) urv;

		select count(distinct(urv.user_id)) into countLevel1 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ut.id=userId))) urv;


	end if;

	if reportLevel =4 then
		select count(distinct(urv.user_id)) into countLevel3 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.relationship_type = 2
				and ut.id=userId)) urv;

		select count(distinct(urv.user_id)) into countLevel2 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ut.id=userId))) urv;

		select count(distinct(urv.user_id)) into countLevel1 from
			(select ur.* from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in


			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ur.related_user_id in

			(select ur.user_id from user_relationship ur
				join user_table ut
				on (ut.id = ur.user_id)
				where ut.deleteflag = 'N'
				and ur.begin_date <= sysdate
				and ur.end_date >= sysdate
				and ut.id=userId)))) urv;


	end if;
	totalCount := countLevel1 + countLevel2 + countLevel3+1;
	end;
	return totalCount;
end;
.
/

create or replace type string_agg_type as object (
  total varchar2(4000),

  static function ODCIAggregateInitialize(sctx IN OUT string_agg_type )
  return number,

  member function ODCIAggregateIterate(self IN OUT string_agg_type, value IN varchar2 )
  return number,

  member function ODCIAggregateTerminate(self IN string_agg_type, returnValue OUT varchar2, flags IN number)
  return number,

  member function ODCIAggregateMerge(self IN OUT string_agg_type, ctx2 IN string_agg_type)
  return number
);
/

create or replace type body string_agg_type is
  static function ODCIAggregateInitialize(sctx IN OUT string_agg_type)
  return number
  is
  begin
    sctx := string_agg_type( null );
    return ODCIConst.Success;
  end;

  member function ODCIAggregateIterate(self IN OUT string_agg_type, value IN varchar2 )
  return number
  is
  begin
    self.total := self.total || ',' || value;
    return ODCIConst.Success;
  end;

  member function ODCIAggregateTerminate(self IN string_agg_type, returnValue OUT varchar2, flags IN number)
  return number
  is
  begin
    returnValue := ltrim(self.total,',');
    return ODCIConst.Success;
  end;

  member function ODCIAggregateMerge(self IN OUT string_agg_type, ctx2 IN string_agg_type)
  return number
  is
  begin
    self.total := self.total || ctx2.total;
    return ODCIConst.Success;
  end;
end;
/

create or replace function stragg(input varchar2)
return varchar2
parallel_enable aggregate using string_agg_type;