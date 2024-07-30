create database if not exists salesdatawalmart;

create table  new_sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float not null,
    total decimal(12,4) not null,
    date datetime not null,
    Time time not null,
    payment_method varchar(15) not null,
    cogs decimal (10,2) not null,
    gross_margin_pct float not null,
    gross_income decimal(12,4) not null,
    rating float 
);

-- -----------------------------------Feature Engineering-----------------------------------------------------------
-- time_of_day(morning,afternoon,evening)

select
	time, 
    (case
		 when time between "00:00:00" and "12:00:00" then "morning"
		 when time between "12:01:00" and "16:00:00" then "afternoon"
		 else "evening"
	end
	)as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day=(
	case
		 when time between "00:00:00" and "12:00:00" then "morning"
		 when time between "12:01:00" and "16:00:00" then "afternoon"
		 else "evening"
	end
	);
    


-- day_name (mon, tue, wed...)
select
	date,dayname(date) from sales;
    
alter table sales add column day_name varchar(10);

update sales set day_name=dayname(date);



-- month_name

select date,monthname(date) from sales;

alter table sales add column month_name varchar(10);

update sales set month_name=monthname(date);



-- -------------------------------------------------Questions----------------------------------------------------------------------------

-- #generic questions --

--  how many unique city,branch does data have

select distinct city,branch from sales;

-- # product questions

-- 1) how many unique product line does data have?

select count(distinct product_line) from sales;

-- 2) common payment method

select payment_method, count(payment_method)as cnt 
from sales
group by payment_method
order by cnt desc; 

-- 3) most selling product_line
select product_line, count(product_line)as cnt 
from sales
group by product_line
order by cnt desc; 

-- 4) what is the total revenue by month ?
select
	month_name as month,
    sum(total) as total_revenue
    from sales
    group by month_name
    order by total_revenue desc;
    
-- 5) what month had the largest COGS (cost of goods sold )
 select month_name as month,
	 sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- 6) what product line had the largest revenue?

select product_line,
	sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- 7) city with largest revenue
select city,
	sum(total) as total_revenue
    from sales
    group by city
    order by total_revenue desc;

-- 8) product_line with largest VAT?

select product_line,
	avg(vat) as avg_tax
    from sales
    group by product_line
    order by avg_tax desc;
    
-- 9) Fetch each product line and add a column to those product line
-- showing "good", "bad". good if its greater that average sales

select avg(quantity) as avg_qnty from sales;

select 
		product_line,
		case
				when avg(quantity) > 6 then "good"
	    else "bad"
	end as remark
from sales
group by product_line;

-- 10)which branch sold more products than average product sold?

select branch,
	sum(quantity) as qnty
from sales
group by branch having sum(quantity) > (select avg(quantity) from sales);

-- 11) most common product_line by gender?
select gender, product_line, count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- 12) average rating of each product_line
select avg(rating) as avg_rating, product_line
from sales
group by product_line
order by avg_rating desc;

-- rounds the value
select round(avg(rating),2) as avg_rating, product_line
from sales
group by product_line
order by avg_rating desc;

-- #sales

-- 1) no. of sales made in each time of the day per weekday(sunday)
select time_of_day, count(*) as total_sales
from sales
where day_name = "sunday"
group by time_of_day
order by total_sales desc;

-- 2)which customer_type brings more revenue
select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- 3)which city has largest tax percent
select city, round(avg(vat), 2) as avg_tax_pct
from sales
group by city
order by avg_tax_pct desc;

-- 4) which customer type pays the most in vat?

select customer_type, avg(vat) as total_tax
from sales
group by customer_type
order by total_tax desc;


-- # Customer

-- 1) unique customer types
select distinct customer_type from sales;

-- 2) unique payment method
select distinct payment_method from sales;

-- 3) most common customer type
select customer_type, count(*) as count
from sales
group by customer_type 
order by count desc;



-- 4) which customer type buys the most
select customer_type,count(*)
from sales
group by customer_type; 

-- 5) what is the gender of most of the customer?
select gender, count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- 6) What is the gender distribution per branch?
select
	gender,
	COUNT(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt desc;



-- 7) which time of the day customer gives most ratings?
select time_of_day day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc; 

-- 8) Which time of the day do customers give most ratings per branch?
select
	time_of_day,
	avg(rating) as avg_rating
from sales
where branch = "A"
group by time_of_day
order by avg_rating desc;

-- 9) which day of the week has best average rating 
select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc; 

-- 10) Which day of the week has the best average ratings per branch?
select
	day_name,
	count(day_name) total_sales
from sales
where branch = "C"
group by day_name
order by total_sales desc;