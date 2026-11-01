/*
 Question: What are the most optimal skills for data engineers—balancing both demand and salary?
 - Create a ranking column that combines demand count and median salary to identify the most valuable skills.
 - Focus only on remote Data Engineer positions with specified annual salaries.
 - Why?
 - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
 - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
 */
SELECT sd.skills as skill,
  ROUND(MEDIAN(jpf.salary_year_avg), 1) as median_salary,
  COUNT(sd.skills) as demand_count,
  ROUND(LN(COUNT(jpf.*)), 1) as in_demand_count,
  ROUND(
    (LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg)) / 1_00_000,
    2
  ) as optimal_score
FROM job_postings_fact as jpf
  INNER JOIN skills_job_dim as sjd ON jpf.job_id = sjd.job_id
  INNER JOIN skills_dim as sd ON sjd.skill_id = sd.skill_id
where (
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
  )
GROUP BY skill
having COUNT(jpf.job_id) >= 100
ORDER BY optimal_score DESC
LIMIT 25;
/*
 Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:
 
 Top Skills by Optimal Score:
 - Terraform leads the list with a $184K median salary and 193 postings, resulting in the highest overall "optimal score".
 - Python and SQL dominate demand (over 1100 postings each), with strong median salaries of $135K and $130K, respectively.
 - AWS (783 postings, $137K median), Spark (503 postings, $140K median), and Airflow (386 postings, $150K median) are all highly sought-after cloud and big data technologies.
 - Kafka offers high compensation ($145K median) and solid demand (292 postings).
 - Tools like Snowflake, Azure, and Databricks each have 250–475 postings and median salaries between $128–$137K.
 
 DevOps & Engineering Tools:
 - Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) stand out for their mix of demand and top median salaries.
 - Git ($140K/208 postings) and Github ($135K/127 postings) have broad utility and competitive compensation.
 
 Noteworthy Languages:
 - Java (303 postings, $135K median) and Scala (247 postings, $137K median) remain strong choices for well-paid data engineering roles.
 - Go ($140K/113 postings) is another programming language with excellent compensation.
 
 Databases & Cloud:
 - Redshift ($130K/274 postings), GCP ($136K/196 postings), Hadoop ($135K/198 postings), NoSQL ($134.4K/193 postings), and MongoDB ($135.8K/136 postings) add to a well-rounded data engineering skill set.
 - R, Pyspark, and BigQuery each deliver competitive salaries and meet the threshold for demand.
 
 Summary:
 Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.
 
 ┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
 │   skill    │ median_salary │ demand_count │ in_demand_count │ optimal_score │
 │  varchar   │    double     │    int64     │     double      │    double     │
 ├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
 │ terraform  │      184000.0 │          193 │             5.3 │          9.68 │
 │ python     │      135000.0 │         1133 │             7.0 │          9.49 │
 │ aws        │      137320.3 │          783 │             6.7 │          9.15 │
 │ sql        │      130000.0 │         1128 │             7.0 │          9.14 │
 │ airflow    │      150000.0 │          386 │             6.0 │          8.93 │
 │ spark      │      140000.0 │          503 │             6.2 │          8.71 │
 │ snowflake  │      135500.0 │          438 │             6.1 │          8.24 │
 │ kafka      │      145000.0 │          292 │             5.7 │          8.23 │
 │ azure      │      128000.0 │          475 │             6.2 │          7.89 │
 │ java       │      135000.0 │          303 │             5.7 │          7.71 │
 │ scala      │      137290.5 │          247 │             5.5 │          7.56 │
 │ kubernetes │      150500.0 │          147 │             5.0 │          7.51 │
 │ git        │      140000.0 │          208 │             5.3 │          7.47 │
 │ databricks │      132750.0 │          266 │             5.6 │          7.41 │
 │ redshift   │      130000.0 │          274 │             5.6 │           7.3 │
 │ gcp        │      136000.0 │          196 │             5.3 │          7.18 │
 │ hadoop     │      135000.0 │          198 │             5.3 │          7.14 │
 │ nosql      │      134415.0 │          193 │             5.3 │          7.07 │
 │ pyspark    │      140000.0 │          152 │             5.0 │          7.03 │
 │ docker     │      135000.0 │          144 │             5.0 │          6.71 │
 │ mongodb    │      135750.0 │          136 │             4.9 │          6.67 │
 │ go         │      140000.0 │          113 │             4.7 │          6.62 │
 │ r          │      134775.0 │          133 │             4.9 │          6.59 │
 │ github     │      135000.0 │          127 │             4.8 │          6.54 │
 │ bigquery   │      135000.0 │          123 │             4.8 │           6.5 │
 └────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
 25 rows                                                           5 columns
 */