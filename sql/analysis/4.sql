/* Question:
   How have user sentiment and rating trends shifted across release periods,
   and are newer games reviewed more critically or more favorably than older ones?
*/


WITH base AS (
  SELECT
    DATE_TRUNC('year', release_date)::date AS year,
    COUNT(*) FILTER (WHERE n_reviews >= 10)  AS n_games_10,
    COUNT(*) FILTER (WHERE n_reviews >= 100) AS n_games_100,
    SUM(n_reviews) FILTER (WHERE n_reviews >= 100) AS total_reviews,
    AVG(bayes_average) FILTER (WHERE n_reviews >= 100) AS avg_bayes,
    (SUM(bayes_average * n_reviews) FILTER (WHERE n_reviews >= 100)::numeric 
       / NULLIF(SUM(n_reviews) FILTER (WHERE n_reviews >= 100), 0)) AS weighted_bayes,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bayes_average) FILTER (WHERE n_reviews >= 100)::numeric AS median_bayes
  FROM games
  WHERE release_date IS NOT NULL
  GROUP BY DATE_TRUNC('year', release_date)
),

yoy_change AS (
  SELECT
    year,
    n_games_10,
    n_games_100,
    total_reviews,
    avg_bayes,
    weighted_bayes,
    median_bayes,
    (avg_bayes - LAG(avg_bayes) OVER (ORDER BY year)) AS yoy_change_avg,
    (weighted_bayes - LAG(weighted_bayes) OVER (ORDER BY year)) AS yoy_change_weighted
  FROM base
)

SELECT
  year,
  n_games_10,
  n_games_100,
  total_reviews,
  ROUND(avg_bayes, 3) AS avg_bayes,
  ROUND(weighted_bayes, 3) AS weighted_bayes,
  ROUND(median_bayes, 3) AS median_bayes,
  ROUND(yoy_change_avg, 3) AS yoy_change_avg,
  ROUND(yoy_change_weighted, 3) AS yoy_change_weighted
FROM yoy_change
WHERE year IS NOT NULL
ORDER BY year;
