select * from(
select distinct t1.workflow_name,
		case when t2.workflow_name is null 
				then 0
				else 
					case when (select count(*) from ctl.emd_workflow_depends d
							where d.workflow_dep_name =t2.workflow_name and d.workflow_name IN('WF_ML_EGIS_ROUTES',
							'WF_GGSN_HUAWAY_CHECK','WF_GGSN_HUAWAY_CHECK_HOURLY','WF_AGG_SUBS_USAGE_GEO_D'))>0
						then 
							case when (select count(*) from ctl.emd_workflow_depends d
							where d.workflow_name =t2.workflow_name and d.workflow_dep_name IN('WF_ML_EGIS_ROUTES',
							'WF_GGSN_HUAWAY_CHECK','WF_GGSN_HUAWAY_CHECK_HOURLY','WF_AGG_SUBS_USAGE_GEO_D'))>0
						then 1
						else 0
					END
						else 1
					END
			END workflow_is_child
		from (
			select 'WF_ML_EGIS_ROUTES' as workflow_name
			union 
			select 'WF_GGSN_HUAWAY_CHECK'
			union 
			select 'WF_GGSN_HUAWAY_CHECK_HOURLY'
			union 
			select 'WF_AGG_SUBS_USAGE_GEO_D'
		) as t1
	left join ctl.emd_workflow_depends as t2 on t1.workflow_name=t2.workflow_name) T1
	where T1.workflow_is_child=0


	
	
	
	
select count(workflow_name), workflow_name from ctl.emd_workflow_depends d
where d.workflow_dep_name ='WF_GGSN_HUAWAY_CHECK' and d.workflow_name IN('WF_ML_EGIS_ROUTES',
'WF_GGSN_HUAWAY_CHECK','WF_GGSN_HUAWAY_CHECK_HOURLY','WF_AGG_SUBS_USAGE_GEO_D')
group by workflow_name 

select count(workflow_name), workflow_name from ctl.emd_workflow_depends d
where d.workflow_name ='WF_GGSN_HUAWAY_CHECK' and d.workflow_dep_name IN('WF_ML_EGIS_ROUTES',
'WF_GGSN_HUAWAY_CHECK','WF_GGSN_HUAWAY_CHECK_HOURLY','WF_AGG_SUBS_USAGE_GEO_D')
group by workflow_name 