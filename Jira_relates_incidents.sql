WITH RECURSIVE temp1 (
		workflow_name
		,workflow_dep_name
		,path
		, LEVEL 
		) AS (

	SELECT impacts.workflow_impact
	,impacts.parent
	, CAST (impacts.workflow_impact AS VARCHAR (10000)) as path
	, 1
	FROM 	
		(select  case when t2.workflow_name is null
				then  t1.workflow_name
			END workflow_impact
			, null as parent
		from (
			select 'WF_ML_EGIS_ROUTES ' as workflow_name
			union 
			select 'WF_GGSN_HUAWAY_CHECK'
			union 
			select 'WF_GGSN_HUAWAY_CHECK_HOURLY'
		) as t1
	left join ctl.emd_workflow_depends as t2 on t1.workflow_name=t2.workflow_name 
	where case when t2.workflow_name is null
			then  t1.workflow_name
			end is not null) as impacts
union
select T1.workflow_name 
	,T1.workflow_dep_name
	, CAST ( temp1.PATH ||'->'|| T1.workflow_name AS VARCHAR(10000)) ,LEVEL + 1
FROM ctl.emd_workflow_depends T1 
INNER JOIN temp1 ON( temp1.workflow_name= T1.workflow_dep_name )
)    
select * from temp1
ORDER BY level LIMIT 500

