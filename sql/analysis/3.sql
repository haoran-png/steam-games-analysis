/* Question:
   Which tags are most predictive of high ratings or strong engagement,
   and do certain tag combinations amplify or dilute the success?
*/


-- Threshold for top 10% by Bayesian average
WITH thr AS (
  SELECT percentile_disc(0.9) WITHIN GROUP (ORDER BY bayes_average) AS top10
  FROM games
),

-- Expand tags into individual rows
all_tags AS (
  SELECT DISTINCT app_id,
    lower(trim(tag)) AS tag
  FROM games
  CROSS JOIN LATERAL regexp_split_to_table(tags, '\s*,\s*') AS tag -- Split tags by comma
),

-- Tags in top 10% of games by Bayesian average
top_tags AS (
  SELECT DISTINCT app_id,
    lower(trim(tag)) AS tag
  FROM games
  JOIN thr ON bayes_average >= thr.top10 -- Only include top 10%
  CROSS JOIN LATERAL regexp_split_to_table(tags, '\s*,\s*') AS tag 
)

-- Final aggregation to compute lift
SELECT
  a.tag,
  COUNT(DISTINCT t.app_id) AS in_top,
  COUNT(DISTINCT a.app_id) AS overall,
  ROUND(
    COUNT(DISTINCT t.app_id)::numeric
    / NULLIF((SELECT COUNT(DISTINCT app_id) FROM top_tags), 0), 4) AS top_share,
  ROUND(
    COUNT(DISTINCT a.app_id)::numeric
    / (SELECT COUNT(DISTINCT app_id) FROM all_tags), 4) AS base_share,
  ROUND(
    NULLIF(COUNT(DISTINCT t.app_id)::numeric/ NULLIF((SELECT COUNT(DISTINCT app_id) FROM top_tags), 0), 0)
    / NULLIF(COUNT(DISTINCT a.app_id)::numeric/ (SELECT COUNT(DISTINCT app_id) FROM all_tags), 0), 2) AS lift
FROM all_tags a
LEFT JOIN top_tags t
  ON t.app_id = a.app_id AND t.tag = a.tag
GROUP BY a.tag
HAVING COUNT(DISTINCT a.app_id) >= 100
ORDER BY lift DESC NULLS LAST, in_top DESC, overall DESC
LIMIT 50;