create table SCHEMA.TABLE as
select 
	precinct,
	a.state,
	countyname,
	this.congressionaldistrict,
	this.statesenatedistrict,
	this.statehousedistrict,
	sum(case when model1 >= 50 and model2 >= 60 then 1 else 0 end) as 'Threshold_1',
	sum(case when model1 >= 60 and model2 >= 70 then 1 else 0 end) as 'Threshold_2',
	sum(case when model1 >= 70 and model2 >= 60 then 1 else 0 end) as 'Threshold_3',
	sum(case when 2008voteHistory is not null and 2010voteHistory is null then 1 else 0 end) as 'Vote_Threshold',
	avg(model3) as 'AVG_model3',
	avg(model2) as 'AVG_model2',
	count(*) as 'Total_Voters'
from
	SCHEMA.TABLE a
	inner join SCHEMA.TABLE b on a.id = b.id and a.state = b.state
	left join SCHEMA.TABLE c on a.id = c.id
	left join SCHEMA.TABLE k on a.id = k.id and a.state = k.state
	left join (
		select 
			a.id,
			a.state,
			case
				when a.state in ('AR', 'CA', 'CO', 'DC', 'HI', 'ID', 'IL', 'IN', 'IA', 'KY', 'ME', 'MA', 'MO', 'MT', 'NE', 'NV', 'NJ', 'NM', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SD', 'UT', 'WA', 'VA', 'WV', 'WI', 'WY', 'TX', 'MI', 'MN', 'NH') then z.congressionaldistrict
				else b.congressionaldistrict end as congressionaldistrict,
			case
				when a.state in ('AR', 'CA', 'CO', 'DC', 'HI', 'ID', 'IL', 'IN', 'IA', 'KY', 'ME', 'MA', 'MO', 'MT', 'NE', 'NV', 'NJ', 'NM', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SD', 'UT', 'WA', 'VA', 'WV', 'WI', 'WY', 'TX', 'MI', 'MN', 'NH') then z.statesenatedistrict
				else c.statesenatedistrict end as statesenatedistrict,
			case	
				when a.state in ('AR', 'CA', 'CO', 'DC', 'HI', 'ID', 'IL', 'IN', 'IA', 'KY', 'ME', 'MA', 'MO', 'MT', 'NE', 'NV', 'NJ', 'NM', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SD', 'UT', 'WA', 'VA', 'WV', 'WI', 'WY', 'TX', 'MI', 'MN', 'NH') then z.statehousedistrict
				else d.statehousedistrict end as statehousedistrict
		from SCHEMA.TABLE a
		inner join SCHEMA.TABLE z on a.id = z.id
		left join SCHEMA.TABLE b on a.id = b.id and a.state = b.state
		left join SCHEMA.TABLE c on a.id = c.id and a.state = c.state
		left join SCHEMA.TABLE d on a.id = d.id and a.state = d.state
	) this on a.id = this.id and a.state = this.state
where
	a.voterstatus in ('active','inactive')
	and a.deceased = 'N'
	and a.customer in ('CUSTOMER1','CUSTOMER2')
group by
	a.state,
	this.congressionaldistrict,
	this.statesenatedistrict,
	this.statehousedistrict,
	countyname,
	precinct
order by
	a.state,
	this.congressionaldistrict,
	this.statesenatedistrict,
	this.statehousedistrict,
	countyname,
	precinct