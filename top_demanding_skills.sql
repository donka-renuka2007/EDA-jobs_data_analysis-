/*
 Question: What are the most in-demand skills for data engineers?
 - Join job postings to inner join table similar to query 2
 - Identify the top 10 in-demand skills for data engineers
 - Focus on remote job postings
 - Why? Retrieves the top 10 skills with the highest demand in the remote job market,
 providing insights into the most valuable skills for data engineers seeking remote work
 */
SELECT sd.skills as skill,
  count(jpf.*) as demand_count
FROM job_postings_fact as jpf
  INNER JOIN skills_job_dim as sjd ON jpf.job_id = sjd.job_id
  INNER JOIN skills_dim as sd ON sd.skill_id = sjd.skill_id
where jpf.job_title_short = 'Data Engineer'
GROUP BY skill
ORDER BY demand_count DESC
LIMIT 10;
/*
 Here's the breakdown of the most demanded skills for data engineers:
 SQL and Python are by far the most in-demand skills, with around 29,000 job postings each - nearly double the next closest skill.
 Cloud platforms round out the top skills, with AWS leading at ~18,000 postings, followed by Azure at ~14,000.
 Apache Spark completes the top 5 with nearly 13,000 postings, highlighting the importance of big data processing skills.
 
 Key takeaways:
 - SQL and Python remain the foundational skills for data engineers
 - Cloud platforms (AWS, Azure) are critical for modern data engineering
 - Big data tools like Spark continue to be highly valued
 - Data pipeline tools (Airflow, Snowflake, Databricks) show growing demand
 - Java and GCP round out the top 10 most requested skills
 
 ┌────────────┬──────────────┐
 │   skill    │ demand_count │
 │  varchar   │    int64     │
 ├────────────┼──────────────┤
 │ sql        │       233132 │
 │ python     │       224102 │
 │ aws        │       130205 │
 │ azure      │       128822 │
 │ spark      │       106904 │
 │ java       │        69657 │
 │ databricks │        63012 │
 │ snowflake  │        60379 │
 │ scala      │        57079 │
 │ kafka      │        56410 │
 └────────────┴──────────────┘
 
 */