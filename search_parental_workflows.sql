SELECT
	*
FROM
	(
		SELECT
			DISTINCT t1.workflow_name,
			CASE
				WHEN t2.workflow_name IS NULL THEN 0
				ELSE CASE
					WHEN (
						SELECT
							count(*)
						FROM
							ctl.emd_workflow_depends d
						WHERE
							d.workflow_dep_name = t2.workflow_name
							AND d.workflow_name IN(
								'WF_ML_EGIS_ROUTES',
								'WF_GGSN_HUAWAY_CHECK',
								'WF_GGSN_HUAWAY_CHECK_HOURLY',
								'WF_AGG_SUBS_USAGE_GEO_D'
							)
					) > 0 THEN CASE
						WHEN (
							SELECT
								count(*)
							FROM
								ctl.emd_workflow_depends d
							WHERE
								d.workflow_name = t2.workflow_name
								AND d.workflow_dep_name IN(
									'WF_ML_EGIS_ROUTES',
									'WF_GGSN_HUAWAY_CHECK',
									'WF_GGSN_HUAWAY_CHECK_HOURLY',
									'WF_AGG_SUBS_USAGE_GEO_D'
								)
						) > 0 THEN 1
						ELSE 0
					END
					ELSE 1
				END
			END workflow_is_child
		FROM
			(
				SELECT
					'WF_ML_EGIS_ROUTES' AS workflow_name
				UNION
				SELECT
					'WF_GGSN_HUAWAY_CHECK'
				UNION
				SELECT
					'WF_GGSN_HUAWAY_CHECK_HOURLY'
				UNION
				SELECT
					'WF_AGG_SUBS_USAGE_GEO_D'
			) AS t1
			LEFT JOIN ctl.emd_workflow_depends AS t2 ON t1.workflow_name = t2.workflow_name
	) T1
WHERE
	T1.workflow_is_child = 0
SELECT
	count(workflow_name),
	workflow_name
FROM
	ctl.emd_workflow_depends d
WHERE
	d.workflow_dep_name = 'WF_GGSN_HUAWAY_CHECK'
	AND d.workflow_name IN(
		'WF_ML_EGIS_ROUTES',
		'WF_GGSN_HUAWAY_CHECK',
		'WF_GGSN_HUAWAY_CHECK_HOURLY',
		'WF_AGG_SUBS_USAGE_GEO_D'
	)
GROUP BY
	workflow_name
SELECT
	count(workflow_name),
	workflow_name
FROM
	ctl.emd_workflow_depends d
WHERE
	d.workflow_name = 'WF_GGSN_HUAWAY_CHECK'
	AND d.workflow_dep_name IN(
		'WF_ML_EGIS_ROUTES',
		'WF_GGSN_HUAWAY_CHECK',
		'WF_GGSN_HUAWAY_CHECK_HOURLY',
		'WF_AGG_SUBS_USAGE_GEO_D'
	)
GROUP BY
	workflow_name