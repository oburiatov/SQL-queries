WITH RECURSIVE temp1 (
	workflow_name,
	workflow_dep_name,
	path,
	LEVEL
) AS (
	SELECT
		impacts.workflow_impact,
		impacts.parent,
		CAST (impacts.workflow_impact AS VARCHAR (10000)) AS path,
		1
	FROM
		(
			SELECT
				CASE
					WHEN t2.workflow_name IS NULL THEN t1.workflow_name
				END workflow_impact,
				NULL AS parent
			FROM
				(
					SELECT
						'WF_ML_EGIS_ROUTES ' AS workflow_name
					UNION
					SELECT
						'WF_GGSN_HUAWAY_CHECK'
					UNION
					SELECT
						'WF_GGSN_HUAWAY_CHECK_HOURLY'
				) AS t1
				LEFT JOIN ctl.emd_workflow_depends AS t2 ON t1.workflow_name = t2.workflow_name
			WHERE
				CASE
					WHEN t2.workflow_name IS NULL THEN t1.workflow_name
				END IS NOT NULL
		) AS impacts
	UNION
	SELECT
		T1.workflow_name,
		T1.workflow_dep_name,
		CAST (
			temp1.PATH || '->' || T1.workflow_name AS VARCHAR(10000)
		),
		LEVEL + 1
	FROM
		ctl.emd_workflow_depends T1
		INNER JOIN temp1 ON(temp1.workflow_name = T1.workflow_dep_name)
)
SELECT
	*
FROM
	temp1
ORDER BY
	LEVEL
LIMIT
	500