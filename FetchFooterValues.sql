SELECT 
    (SELECT TOP 1 id FROM FOOTER WHERE id IS NOT NULL ORDER BY id DESC) AS last_id,
    (SELECT TOP 1 car FROM FOOTER WHERE car IS NOT NULL ORDER BY id DESC) AS last_car,
    (SELECT TOP 1 length FROM FOOTER WHERE length IS NOT NULL ORDER BY id DESC) AS last_length,
    (SELECT TOP 1 width FROM FOOTER WHERE width IS NOT NULL ORDER BY id DESC) AS last_width,
    (SELECT TOP 1 height FROM FOOTER WHERE height IS NOT NULL ORDER BY id DESC) AS last_height;

select *
	, sum(case when car is null then 0 else 1 end) over(order by id) as car_segment
	, sum(case when length is null then 0 else 1 end) over(order by id) as length_segment
	, sum(case when width is null then 0 else 1 end) over(order by id) as width_segment
	, sum(case when height is null then 0 else 1 end) over(order by id) as height_segment
	from footer

with cte as
	(select *
	, sum(case when car is null then 0 else 1 end) over(order by id) as car_segment
	, sum(case when length is null then 0 else 1 end) over(order by id) as length_segment
	, sum(case when width is null then 0 else 1 end) over(order by id) as width_segment
	, sum(case when height is null then 0 else 1 end) over(order by id) as height_segment
	from footer)


select 
  first_value(car) over(partition by car_segment order by id) as new_car
, first_value(length) over(partition by length_segment order by id) as new_length 
, first_value(width) over(partition by width_segment order by id) as new_width
, first_value(height) over(partition by height_segment order by id) as new_height
from cte 
order by id desc
