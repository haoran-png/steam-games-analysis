/* Question:
   How do different game genres influence both player satisfaction and long-term engagement?
   Are some genres consistently over or underperforming compared to others?
*/


-- Expand genres into individual rows
WITH genre_list AS (
  SELECT
    trim(lower(unnest(string_to_array(genres, ',')))) AS genre,
    positive::float AS pos,
    negative::float AS neg,
    bayes_average,
    average_playtime_forever::float AS playtime
  FROM games
),

-- Aggregate the data by genre
agg AS (
  SELECT
    genre,
    COUNT(*) AS n_games,
    AVG(pos / NULLIF(pos + neg, 0)) AS avg_ratio,
    SUM(pos) / NULLIF(SUM(pos + neg), 0) AS w_ratio,
    AVG(bayes_average) AS mean_bayes,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY bayes_average) AS med_bayes,
    AVG(playtime) AS avg_playtime,
    SUM(pos) AS total_positive,
    SUM(neg) AS total_negative
  FROM genre_list
  GROUP BY genre
)

-- Final output with rounding and consistency metrics
SELECT
  genre,
  n_games,
  total_positive,
  total_negative,
  ROUND(avg_ratio::numeric, 4) AS avg_positive_ratio,
  ROUND(w_ratio::numeric, 4) AS weighted_positive_ratio,
  ROUND(mean_bayes::numeric, 4) AS avg_bayes_rating,
  ROUND(med_bayes::numeric, 4) AS median_bayes_rating,
  ROUND(avg_playtime::numeric, 0) AS avg_playtime_hours,
  ROUND((w_ratio - avg_ratio)::numeric, 4)  AS ratio_gap,
  ROUND((mean_bayes - med_bayes)::numeric, 4) AS rating_gap
FROM agg
WHERE n_games >= 20
ORDER BY avg_bayes_rating DESC;
