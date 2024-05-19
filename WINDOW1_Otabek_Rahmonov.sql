WITH ranked_sales AS (
    SELECT
        s.cust_id,
        t.calendar_year AS sale_year,
        c.channel_desc AS sales_channel,
        SUM(s.amount_sold) AS total_sales,
        RANK() OVER (PARTITION BY t.calendar_year, c.channel_desc ORDER BY SUM(s.amount_sold) DESC) AS sales_rank
    FROM
        sales s
    JOIN
        channels c ON s.channel_id = c.channel_id
    JOIN
        times t ON s.time_id = t.time_id
    WHERE
        t.calendar_year IN (1998, 1999, 2001)
    GROUP BY
        s.cust_id, t.calendar_year, c.channel_desc
),
top_customers AS (
    SELECT
        cust_id,
        sale_year,
        sales_channel,
        total_sales
    FROM
        ranked_sales
    WHERE
        sales_rank <= 300
)
SELECT
    cust_id AS customer_id,
    sale_year,
    sales_channel,
    ROUND(total_sales, 2) AS formatted_total_sales
FROM
    top_customers
ORDER BY
    sale_year, sales_channel, total_sales DESC;
