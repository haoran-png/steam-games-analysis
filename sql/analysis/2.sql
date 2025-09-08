/* Question:
   How does pricing affect both reach and engagement,
   and where is the “value-for-money” sweet spot across the market?
*/


WITH base AS (
  SELECT
    CASE -- bucketed price ranges
      WHEN price = 0 THEN 0
      WHEN price >= 60 THEN 13
      ELSE width_bucket(price, 0, 60, 12)
    END AS price_bucket,
    CASE -- labels for price ranges
      WHEN price = 0 THEN '€0 (free)'
      WHEN price >= 60 THEN '€60+'
      ELSE format('€%s–€%s',(
        (width_bucket(price,0,60,12)-1)*5),
        (width_bucket(price,0,60,12)*5))
    END AS price_range,

    price AS price,
    estimated_average_owners AS owners,
    average_playtime_forever AS playtime,
    bayes_average AS rating
  FROM games
)

-- Analyzing metrics by price bucket
SELECT
  price_bucket,
  price_range,
  COUNT(*) AS n_games,
  ROUND(AVG(owners)) AS avg_owners,
  ROUND(AVG(playtime)) AS avg_playtime,
  ROUND(AVG(playtime / NULLIF(price,0)), 2) AS playtime_per_euro,
  ROUND(AVG(owners / NULLIF(price,0)), 2) AS owners_per_euro,
  ROUND(AVG(rating), 3) AS avg_rating,
  ROUND(AVG(rating / NULLIF(price,0)), 3) AS rating_per_euro
FROM base
GROUP BY price_bucket, price_range
ORDER BY price_bucket;