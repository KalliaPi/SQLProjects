--Updating rating system column

SELECT rating,
CASE
    when rating = 'R' THEN 'Restricted under the age of 17'
	when rating='Approved' THEN 'Suitable for all audiences'
	when rating='G' THEN 'General Audiences'
	when rating='NC-17' THEN 'No Children Under 17 Admitted'
	when rating='PG' THEN  'Parental Guidance Suggestedd'
	when rating='PG-13' THEN 'Parental Guidance Suggested - Some Material May Not Be Suitable for Children Under 13'
	when rating='TV-14' THEN 'Television - Parents Strongly Cautioned'
	when rating='TV-MA' THEN 'Television - Mature Audience'
	when rating='TV-PG' THEN 'Television - Parental Guidance Suggested'
	ELSE rating
	END
FROM MovieProject..movies


UPDATE MovieProject..movies
SET rating=CASE
    when rating = 'R' THEN 'Restricted under the age of 17'
	when rating='Approved' THEN 'Suitable for all audiences'
	when rating='G' THEN 'General Audiences'
	when rating='NC-17' THEN 'No Children Under 17 Admitted'
	when rating='PG' THEN  'Parental Guidance Suggestedd'
	when rating='PG-13' THEN 'Parental Guidance Suggested - Some Material May Not Be Suitable for Children Under 13'
	when rating='TV-14' THEN 'Television - Parents Strongly Cautioned'
	when rating='TV-MA' THEN 'Television - Mature Audience'
	when rating='TV-PG' THEN 'Television - Parental Guidance Suggested'
	ELSE rating
	END
	

-- Budget spent on movies by companies

SELECT name,budget, company, year2, votes, score
from MovieProject..movies
order by year


-- Top 5 most voted movies

SELECT TOP 5 name, votes, writer, company, score, genre
from MovieProject..movies
order by 2 desc


-- Number of Movies written by each author

SELECT writer, name, votes
,count(votes) over (partition by writer) as MovieCount
FROM  MovieProject..movies
Order by MovieCount desc


-- TOP 10 Movies with highest gross

SELECT TOP 10 m1.name, m1.gross, m1.budget, m2.score, m2.votes
FROM MovieProject..movies m1
JOIN MovieProject..movies m2
ON m1.name = m2.name
WHERE m1.gross > m1.budget 
ORDER BY gross desc


-- Countries with highest gross profit

select country2, max(gross) as GrossProfit
 from MovieProject..movies
 group by country2
 order by GrossProfit desc


-- Movies for everyone to watch

select name, rating, genre, company
 from MovieProject..movies
 where rating='General Audiences'


-- most voted Genres

select genre, votes
from MovieProject..movies a
where votes IN (
  select MAX(votes)
  from MovieProject..movies
  where genre = a.genre
)
order by votes desc


-- Creating separate column for Month

SELECT
 Parsename(replace( released,',','.') ,2) as Month
 from MovieProject..movies

ALTER TABLE MovieProject..movies
add Month nvarchar(255);

UPDATE MovieProject..movies
SET Month=Parsename(replace( released,',','.') ,2)


-- Creating separate column for year

SELECT 
 SUBSTRING(released, CHARINDEX(',', released) +1,6) AS year2
 FROM MovieProject..movies

ALTER TABLE MovieProject..movies
add year2 nvarchar(255);

UPDATE  MovieProject..movies
SET year2=SUBSTRING(released, CHARINDEX(',', released) +1,6)
WHERE ISNUMERIC(SUBSTRING(released, CHARINDEX(',', released) +1,6)) = 1


-- Creating separate column for country

SELECT
 REPLACE(SUBSTRING(released, CHARINDEX('(', released) + 1, LEN(released) - CHARINDEX('(', released) - 1), ')', '') AS country2
 FROM MovieProject..movies

 ALTER TABLE MovieProject..movies
 add country2 nvarchar(255);

 UPDATE MovieProject..movies
 SET country2=REPLACE(SUBSTRING(released, CHARINDEX('(', released) + 1, LEN(released) - CHARINDEX('(', released) - 1), ')', '')

 
 -- Creating views

 create view CountriesWithHighestGross as
 SELECT country2, max(gross) as GrossProfit
 FROM MovieProject..movies
 WHERE gross>7000000000
 GROUP BY country2

 create view Top10Movies as
 SELECT TOP 10 m1.name, m1.gross, m1.budget, m2.score, m2.votes
 FROM MovieProject..movies m1
 JOIN MovieProject..movies m2
 ON m1.name = m2.name
 WHERE m1.gross > m1.budget 
 ORDER BY gross desc

 create view MovieCount as
 SELECT writer, name, votes
,count(votes) over (partition by writer) as MovieCount
 FROM  MovieProject..movies
 --Order by MovieCount desc

 create view MostVotedGenre as
 select genre, votes
from MovieProject..movies a
where votes IN (
  select MAX(votes)
  from MovieProject..movies
  where genre = a.genre
)
--order by votes desc