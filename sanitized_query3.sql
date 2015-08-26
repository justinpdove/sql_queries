select distinct median(c.model1) over (partition by b.countyname) as 'median_model1', 
	a.state, 
	b.countyname
from SCHEMA.TABLE a
inner join SCHEMA.TABLE b on a.id = b.id and a.state = b.state
inner join SCHEMA.TABLE c on a.dwid = c.dwid and a.state = c.state
where a.state = 'RI'
and lower(customer) = 'customer'
group by a.state, b.countyname, c.model1