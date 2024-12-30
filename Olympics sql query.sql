
-- 1
Select count(distinct(games)) as Total_olympic_games
FROM olympics.athelete_details;

-- 2
SELECT DISTINCT(games) AS Total_olympic_games, year, season, city
FROM athelete_details
ORDER BY year;

-- 3
SELECT games, COUNT(DISTINCT(TEAM)) AS total_countries
FROM athelete_details 
GROUP BY games ORDER BY total_countries DESC;

-- 4
SELECT games, COUNT(DISTINCT(TEAM)) AS total_countries
FROM athelete_details 
GROUP BY games ORDER BY total_countries DESC
LIMIT 1;

SELECT games, COUNT(DISTINCT(TEAM)) AS total_countries
FROM athelete_details 
GROUP BY games ORDER BY total_countries ASC
LIMIT 1;

-- 5
SELECT team, COUNT(DISTINCT(GAMES)) AS total_games
FROM athelete_details
GROUP BY team
HAVING COUNT(DISTINCT (GAMES)) = (SELECT COUNT(DISTINCT (GAMES)) FROM athelete_details);

-- 6
SELECT sport 
FROM athelete_details
WHERE season = 'summer' 
GROUP BY sport
HAVING COUNT(DISTINCT year) = (SELECT COUNT(DISTINCT year) 
							FROM athelete_details WHERE season = 'Summer');
                            
-- 7
SELECT sport FROM athelete_details
GROUP BY sport
HAVING COUNT(DISTINCT (games)) = 1;

-- 8
SELECT games, count(DISTINCT(sport)) FROM athelete_details
GROUP BY games;

-- 9
SELECT * FROM athelete_details
WHERE medal = "gold"
GROUP BY name ORDER BY age DESC
LIMIT 5;

-- 10
SELECT 
    SUM(CASE WHEN sex = 'm' THEN 1 ELSE 0 END) AS total_male,
    SUM(CASE WHEN sex = 'f' THEN 1 ELSE 0 END) AS total_female,
    ROUND(SUM(CASE WHEN sex = 'm' THEN 1 ELSE 0 END) / 
          SUM(CASE WHEN sex = 'f' THEN 1 ELSE 0 END), 2) AS male_to_female_ratio
FROM athelete_details;

-- 11
Select name, count(medal) FROM athelete_details
WHERE medal = "gold" 
GROUP BY name ORDER BY count(medal) DESC
LIMIT 5;

-- 12
Select name, count(medal) FROM athelete_details
GROUP BY name ORDER BY count(medal) DESC
LIMIT 5;

-- 13
Select team, count(medal) FROM athelete_details
GROUP BY team ORDER BY count(medal) DESC
LIMIT 5;

-- 14
SELECT team,
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
FROM athelete_details
GROUP BY team
ORDER BY gold_medals DESC , silver_medals DESC, bronze_medals DESC;

-- 15
SELECT games, team,
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
FROM athelete_details
GROUP BY team ORDER BY games;

-- 16
WITH MedalCounts AS (
    SELECT Year, team,
        SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
        SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
        SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
    FROM athelete_details
    GROUP BY Year, team
)
SELECT Year, team,
    'Gold' AS medal_type,
    team AS gold_country,
    gold_medals AS gold_count
FROM MedalCounts
WHERE gold_medals = (SELECT MAX(gold_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team)

UNION ALL

SELECT Year, team,
    'Silver' AS medal_type,
    team AS silver_country,
    silver_medals AS silver_count
FROM MedalCounts
WHERE silver_medals = (SELECT MAX(silver_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team)

UNION ALL

SELECT Year, team,
    'Bronze' AS medal_type,
    team AS bronze_country,
    bronze_medals AS bronze_count
FROM MedalCounts
WHERE bronze_medals = (SELECT MAX(bronze_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team);

-- 17
WITH MedalCounts AS (SELECT Year, team,
        SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
        SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
        SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals,
        SUM(CASE WHEN Medal IN ('Bronze', 'Gold', 'Silver') THEN 1 ELSE 0 END) AS total_medals
		FROM athelete_details GROUP BY Year, team)
	SELECT Year, team, 'Gold' AS medal_type, team AS gold_country, gold_medals AS gold_count
	FROM MedalCounts
	WHERE gold_medals = (SELECT MAX(gold_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team)
UNION ALL
	SELECT Year, team, 'Silver' AS medal_type, team AS silver_country, silver_medals AS silver_count
	FROM MedalCounts
	WHERE silver_medals = (SELECT MAX(silver_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team)
UNION ALL
	SELECT Year, team, 'Bronze' AS medal_type, team AS bronze_country, bronze_medals AS bronze_count
	FROM MedalCounts
	WHERE bronze_medals = (SELECT MAX(bronze_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team)
UNION ALL
	SELECT Year, team, 'Total' AS medal_type, team AS MAX_Medal_country, total_medals AS total_count
	FROM MedalCounts
	WHERE bronze_medals = (SELECT MAX(total_medals) FROM MedalCounts WHERE Year = MedalCounts.Year AND team = MedalCounts.team);
    
-- 18
WITH MedalCounts AS (SELECT Year, team,
        SUM(CASE WHEN Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
        SUM(CASE WHEN Medal = 'Silver' THEN 1 ELSE 0 END) AS silver_medals,
        SUM(CASE WHEN Medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_medals
    FROM athelete_details GROUP BY team)

SELECT team, gold_medals, silver_medals, bronze_medals
FROM MedalCounts
WHERE gold_medals = 0 AND (silver_medals > 0 OR bronze_medals > 0)
ORDER BY team;

-- 19
Select sport, team, count(medal) FROM athelete_details
WHERE team = "india"
GROUP BY sport, team ORDER BY count(medal) DESC
LIMIT 1;

-- 20
SELECT games, sport, team, COUNT(*) AS total_medals
FROM athelete_details
WHERE team = 'India' AND Sport = 'Hockey'AND Medal IS NOT NULL
GROUP BY games, team
ORDER BY games DESC, team;
