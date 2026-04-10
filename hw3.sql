/*
Rohita Konjeti
1002141462
CSE 3330 IMDb Homework
*/
/*
Query 1
For each year from 2000 to 2009, calculate the total number and the average of
the ratings (rounded to 4 decimal places) of the movies that were released. The
output must be sorted by the average of the ratings in the decreasing order.
*/

SELECT tb.STARTYEAR ,COUNT(*) AS MOVIES, ROUND(AVG(tr.AVERAGERATING),4) AS AVG
FROM
    imdb00.TITLE_BASICS tb, imdb00.TITLE_RATINGS tr
WHERE
    tb.TCONST=tr.TCONST AND
    tb.TITLETYPE='movie' AND tb.STARTYEAR >='2000'AND tb.STARTYEAR<='2009' AND tr.NUMVOTES >=150000
GROUP BY
    tb.STARTYEAR
ORDER BY
    AVG DESC;
    
/* OUTPUT
STARTYEAR      MOVIES        AVG
---------- ---------- ----------
2002               36     7.2667
2006               46     7.2152
2000               35     7.2029
2001               38     7.1395
2005               39     7.1256
2004               60     7.1183
2007               63     7.0857
2003               36     7.0833
2009               54     7.0815
2008               60     6.9583

10 rows selected.
*/
-- ================================================
/*
Query 2
Find the list of top tvseries along with the start year and its average rating. The
output must be sorted by the average of the ratings in the decreasing order.
*/
SET LINESIZE 2000
SET PAGESIZE 2000
COLUMN TOP_TVSERIES FORMAT A30
COLUMN TVSERIES_STARTYEAR FORMAT A30
COLUMN AVG_TVSERIES_RATING FORMAT 9.99999999
SELECT tb.PRIMARYTITLE AS TOP_TVSERIES, tb.STARTYEAR AS TVSERIES_STARTYEAR, AVG(tr.AVERAGERATING) AS AVG_TVSERIES_RATING
FROM imdb00.TITLE_BASICS tb, imdb00.TITLE_RATINGS tr, imdb00.TITLE_EPISODE te
WHERE
    te.TCONST=tr.TCONST AND tb.TITLETYPE='tvSeries' AND tb.TCONST=te.PARENTTCONST 
    GROUP BY
        tb.STARTYEAR, tb.TCONST, tb.PRIMARYTITLE
        HAVING
            SUM(tr.NUMVOTES)>= 450000 AND AVG(tr.AVERAGERATING) >= 8.0
            ORDER BY
                AVG_TVSERIES_RATING DESC;
/*OUTPUT
TOP_TVSERIES                   TVSERIES_STARTYEAR             AVG_TVSERIES_RATING
------------------------------ ------------------------------ -------------------
Attack on Titan                2013                                    9.08020833
Breaking Bad                   2008                                    8.95161290
Better Call Saul               2015                                    8.79500000
Game of Thrones                2011                                    8.75068493
The Sopranos                   1999                                    8.62209302
Stranger Things                2016                                    8.60294118
Lost                           2004                                    8.52100840
Regular Show                   2009                                    8.48938776
Dexter                         2006                                    8.48333333
House                          2004                                    8.42954545
Rick and Morty                 2013                                    8.42745098
Supernatural                   2005                                    8.37217125
Friends                        1994                                    8.32212766
Seinfeld                       1989                                    8.29942197
Arrow                          2012                                    8.18058824
The Office                     2005                                    8.09574468
How I Met Your Mother          2005                                    8.02692308
Buffy the Vampire Slayer       1997                                    8.00620690

18 rows selected.
*//*
-- ================================================
Query 3
For each year from 2005 to 2019 and for the Adventure genre, find out the lead
actor/actress names with the highest average rating. In case, there are multiple
actors/actresses with the same highest average rating, you need to display all of
them.
*/

SET LINESIZE 2000
SET PAGESIZE 2000
COLUMN YEAR FORMAT A20
COLUMN GENRE FORMAT A20
COLUMN HIGHEST_AVG_ACTORRATING FORMAT 9.99999999
COLUMN MOST_POPULAR_ACTOR FORMAT A30
SELECT tb.startyear AS YEAR, 'Adventure' AS GENRE, ROUND(AVG(tr.averagerating),4) AS HIGHEST_AVG_ACTORRATING, nb.primaryname AS MOST_POPULAR_ACTOR
FROM imdb00.TITLE_BASICS tb, imdb00.TITLE_RATINGS tr, imdb00.TITLE_PRINCIPALS tp, imdb00.NAME_BASICS nb
WHERE tb.TCONST=tr.TCONST AND tb.TCONST = tp.TCONST AND tp.NCONST = nb.NCONST
    AND tb.TITLETYPE='movie' AND tb.startyear<= '2019' AND tb.startyear>= '2005' 
    AND tr.NUMVOTES>=100000 AND tp.CATEGORY IN ('actress','actor') AND tp.ORDERING IN('1','2') AND tb.GENRES LIKE '%Adventure%'
GROUP BY tb.startyear, nb.NCONST, nb.PRIMARYNAME
HAVING AVG(tr.averagerating)>=ALL
    (SELECT AVG(tr1.averagerating)
    FROM imdb00.TITLE_BASICS tb1, imdb00.TITLE_RATINGS tr1, imdb00.TITLE_PRINCIPALS tp1, imdb00.NAME_BASICS nb1
    WHERE tb1.TCONST=tr1.TCONST AND tb1.TCONST = tp1.TCONST
    AND tb1.TITLETYPE='movie' AND tb1.startyear=tb.startyear 
    AND tr1.NUMVOTES>=100000 AND tp1.CATEGORY IN ('actress','actor') AND tp1.ORDERING IN('1','2') AND tb1.GENRES LIKE '%Adventure%'
    GROUP BY tb1.startyear, tp1.NCONST)
ORDER BY tb.startyear ASC;

/*





*/