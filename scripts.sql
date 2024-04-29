select cpn.per_id, cpn.entity_name, cap.acct_id , cap.acct_rel_type 
from 
	ci_acct_per cap
	left join ci_per_name cpn on cap.per_id = cpn.per_id ;
	
select cpn.entity_name as owner_name, cpn2.entity_name as family_member_name
from 
	ci_per_name cpn 
	left join ci_acct_per cap on cap.per_id = cpn.per_id
	left join ci_acct_per cap2 on cap2.acct_id = cap.acct_id 
	left join ci_per_name cpn2 on cpn2.per_id = cap2.per_id
WHERE cap.main_cust_sw  = 'Y' and cap.acct_rel_type = 'FMLMMBRA';

select cpn1.per_id,cpn2.entity_name 
from (select cpn.per_id
	from ci_acct_per cap 
	left join ci_per_name cpn on cpn.per_id = cap.per_id
	group by cpn.per_id
	having count(cap.acct_id) > 1) as cpn1
left join ci_per_name cpn2 on cpn2.per_id = cpn1.per_id;

select ca.acct_id, cac.char_val, cac.effdt
from ci_acct ca 
left join(
	select * from (
		select *,
		row_number() over(partition by acct_id order by effdt DESC) as row_num	
		from (
			select * from ci_acct_char
			where char_type_cd = 'PENI-PRM'
			) peni_prm_cac
			) cac_rang
	where row_num = 1) cac on cac.acct_id = ca.acct_id;



/*select *,
	row_number() over(partition by acct_id order by effdt) row_num
from (
	select cac.acct_id, cac.char_type_cd, cac.char_val , cac.effdt ,cpn.per_id, cpn.entity_name
	from ci_acct_char cac 
	left join ci_acct_per cap on cap.acct_id  = cac.acct_id 
	left join ci_per_name cpn on cpn.per_id  = cap.per_id 
	where cac.char_type_cd = 'OTDELEN' and cap.acct_rel_type = 'OSNOV'
) sub_q */


select DISTINCT cpn.per_id, cpn.entity_name
from ci_acct_char cac 
left join ci_acct_per cap on cap.acct_id  = cac.acct_id 
left join ci_per_name cpn on cpn.per_id  = cap.per_id 
left join ci_acct_char cac2  on cap.acct_id  = cac2.acct_id 
where cac.char_type_cd = 'OTDELEN' and cac.effdt <= '2015-01-01' and cap.acct_rel_type = 'OSNOV' and cac2.effdt > '2015-01-01'
and cac.char_val <> cac2.char_val


select sub_q1.acct_id
from (
	select acct_id from (
		select * from ci_sa cs 
		where sa_type_cd != 'PEREPL'
	) cs2
	group by acct_id) sub_q1
left join (
	select * from ci_sa cs 
	where sa_type_cd = 'PEREPL'
	) sub_q2 on sub_q1.acct_id = sub_q2.acct_id
where sub_q2.acct_id is null or sub_q2.acct_id = ''


select *
from ci_acct ca 
order by setup_dt 
limit 1


