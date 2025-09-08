/* Question:
   Which developer strategies are most consistently linked to highly rated or widely adopted titles?
*/

WITH base AS (
  SELECT
    app_id,
    developers,
    bayes_average,
    n_reviews,
    release_date,
    tags,
    NTILE(10) OVER (PARTITION BY EXTRACT(YEAR FROM release_date)
                    ORDER BY n_reviews DESC) AS top10_range -- separating the reviews into 10 groups per year
  FROM games
  WHERE n_reviews > 0
),

agg AS (
  SELECT
    developers,
    COUNT(*) AS n_games,
    SUM(n_reviews) AS sum_reviews,
    AVG(bayes_average) AS avg_bayes,
    SUM(bayes_average * n_reviews)::numeric / NULLIF(SUM(n_reviews),0) AS weighted_bayes,
    AVG((top10_range = 1)::int) AS pct_top10_games, -- top 10% of games per year
    STDDEV_POP(bayes_average) AS bayes_stability_raw -- standard deviation of bayes_average for stability
  FROM base
  GROUP BY developers
),

-- calculate tag stats per developer
dev_tag_stats AS (
  SELECT
    b.developers,
    lower(trim(t)) AS tag,
    COUNT(*) AS n_games_tag, -- number of games with this tag by this developer
    AVG(b.bayes_average) AS avg_bayes_tag
  FROM base b
  CROSS JOIN LATERAL regexp_split_to_table(b.tags, '\s*,\s*') AS t -- splitting the tags into multiple rows
  WHERE b.tags IS NOT NULL AND b.tags <> ''
  GROUP BY b.developers, lower(trim(t))
),

-- rank tags per developer based on their performance vs the developer average (+ small filltering)
ranked_tags AS (
  SELECT
    a.developers,
    a.avg_bayes,
    a.weighted_bayes,
    a.pct_top10_games,
    a.bayes_stability_raw,
    d.tag,
    d.n_games_tag,
    d.avg_bayes_tag,
    (d.avg_bayes_tag - a.avg_bayes) AS tag_delta_vs_dev, -- how much better(positive)/worse(negative) this tag performs vs the developer average
    ROW_NUMBER() OVER (
      PARTITION BY a.developers
      ORDER BY (d.avg_bayes_tag - a.avg_bayes) DESC, d.n_games_tag DESC
    ) AS tag_rank -- rank tags based on tag_delta_vs_dev
  FROM agg a
  JOIN dev_tag_stats d USING (developers)
  WHERE a.n_games >= 15
    AND a.sum_reviews >= 20000
    AND d.n_games_tag >= 3
)

SELECT
  developers,
  ROUND(avg_bayes, 3) AS dev_avg_bayes,
  ROUND(weighted_bayes, 3) AS dev_weighted_bayes,
  ROUND((pct_top10_games*100), 1) AS dev_top10_games,
  ROUND(bayes_stability_raw, 4) AS dev_bayes_stability,
  tag,
  n_games_tag,
  ROUND(avg_bayes_tag, 3) AS avg_bayes_tag,
  ROUND(tag_delta_vs_dev, 3) AS tag_delta_vs_dev
FROM ranked_tags
WHERE tag_rank <= 3
ORDER BY developers, tag_rank;
