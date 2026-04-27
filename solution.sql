---n this challenge you will write an SQL `SELECT` query that joins various tables to figure out what titles each author has published at which publishers. Your output should have at least the following columns:
SELECT
	authors.au_id AS "Author ID",
	authors.au_lname AS "Last name",
	authors.au_fname AS "First name",
	titles.title AS "Title",
	publishers.pub_name AS "Publisher"
	
FROM
	authors, titles, publishers, titleauthor
	
WHERE
	authors.au_id == titleauthor.au_id AND
	titleauthor.title_id == titles.title_id AND
	titles.pub_id == publishers.pub_id;
	
---Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher. Your output should look something like below:
	SELECT 
    a.au_id AS "AUTHOR ID",
    a.au_lname AS "LAST NAME",
    a.au_fname AS "FIRST NAME",
    (SELECT pub_name FROM publishers WHERE pub_id = (
        SELECT pub_id FROM titles WHERE title_id = ta.title_id
    )) AS "PUBLISHER",
    COUNT(ta.title_id) AS "TITLE COUNT"
FROM authors a, titleauthor ta
WHERE a.au_id = ta.au_id
GROUP BY 
    a.au_id, 
    a.au_lname, 
    a.au_fname,
    (SELECT pub_id FROM titles WHERE title_id = ta.title_id);
	
---Who are the top 3 authors who have sold the highest number of titles? Write a query to find out.
SELECT 
    a.au_id AS "AUTHOR ID",
    a.au_lname AS "LAST NAME",
    a.au_fname AS "FIRST NAME",
    SUM((SELECT qty FROM sales WHERE title_id = ta.title_id LIMIT 1)) AS "TOTAL"
FROM authors a, titleauthor ta
WHERE a.au_id = ta.au_id
GROUP BY a.au_id, a.au_lname, a.au_fname
ORDER BY "TOTAL" DESC
LIMIT 3;

---Now modify your solution in Challenge 3 so that the output will display all 23 authors instead of the top 3. Note that the authors who have sold 0 titles should also appear in your output (ideally display `0` instead of `NULL` as the `TOTAL`). Also order your results based on `TOTAL` from high to low.
SELECT 
    a.au_id AS "AUTHOR ID",
    a.au_lname AS "LAST NAME",
    a.au_fname AS "FIRST NAME",
    COALESCE((
        SELECT SUM(qty) FROM sales WHERE title_id IN (
            SELECT title_id FROM titleauthor WHERE au_id = a.au_id
        )
    ), 0) AS "TOTAL"
FROM authors a
ORDER BY "TOTAL" DESC;