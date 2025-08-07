select * from BlinkIT_Data

select count(*) from BlinkIT_Data -- Want to see number of row


--Update Records
update BlinkIT_Data
set Item_Fat_Content = 
case 
when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end


select distinct (item_fat_content) from BlinkIT_Data -- Confirms the update by reflecting distinct values

-- Get total Sales and show in millions
select cast(sum(Total_Sales)/1000000 as decimal(10,2))AS Total_Sales_Millions 
from  BlinkIT_Data 

-- Get the average sales 
select cast(avg (Total_Sales) as decimal(10,0))AS Avg_Sales from BlinkIT_Data

-- Number of items bought
select count(*) as Total_Item_Bought from BlinkIT_Data

-- What years have we been operating
select distinct (Outlet_Establishment_Year) from BlinkIT_Data

-- Average Rating
select cast(avg(Rating) as decimal(10,2)) As Average_Rating from BlinkIT_Data


-- Details on Fat content
select Item_Fat_Content, 
	cast(sum(Total_Sales) /1000 as decimal(10,2)) As Total_Sales, 
	cast(avg(Total_Sales) as decimal(10,2)) As Average_Sales, 
	count(*) as Total_Item_Bought,
	cast(avg(Rating) as decimal(10,2)) As Average_Rating 
from BlinkIT_Data
--where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by cast(sum(Total_Sales) as decimal(10,2)) desc 

-- KPIs by Item type
select 
	Top 5
	Item_Type, 
	cast(sum(Total_Sales) as decimal(10,2)) As Total_Sales, 
	cast(avg(Total_Sales) as decimal(10,2)) As Average_Sales, 
	count(*) as Total_Item_Bought,
	cast(avg(Rating) as decimal(10,2)) As Average_Rating 
from BlinkIT_Data
--where Outlet_Establishment_Year = 2022
group by Item_Type
order by cast(sum(Total_Sales) as decimal(10,2)) desc 

--Total Sales of each product per outlet
Select Outlet_Location_Type, 
	isnull([Low Fat], 0) As Low_Fat,
	isnull([Regular], 0) As Regular
from
(select Outlet_Location_Type, Item_Fat_Content,
	cast(sum(Total_Sales) as decimal(10,2)) As Total_Sales 
from BlinkIT_Data
--where Outlet_Establishment_Year = 2022
group by Outlet_Location_Type, Item_Fat_Content
) As SourceTable
Pivot
(
	sum(Total_Sales)
	for Item_Fat_Content in ([Low Fat], [Regular])
)As PivotTable


-- KPIs by year
select Outlet_Establishment_Year,
	cast(sum(Total_Sales) as decimal(10,2)) As Total_Sales ,
	cast(avg(Total_Sales) as decimal(10,2)) As Average_Sales, 
	count(*) as Total_Item_Bought,
	cast(avg(Rating) as decimal(10,2)) As Average_Rating
from BlinkIT_Data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc

-- Total Sales and Percentage Contribution per Outlet Size
select 
	Outlet_Size,	
	Cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
	cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) As decimal(10,2)) as Percentage_Sales
	from BlinkIT_Data
	group by Outlet_Size
	order by Total_Sales asc

-- KPIs by Outlet location Type
select Outlet_Location_Type,
	cast(sum(Total_Sales) as decimal(10,2)) As Total_Sales ,
	cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) As decimal(10,2)) As Percen_tage,
	cast(avg(Total_Sales) as decimal(10,2)) As Average_Sales, 
	count(*) as Total_Item_Bought,
	cast(avg(Rating) as decimal(10,2)) As Average_Rating
from BlinkIT_Data
group by Outlet_Location_Type
order by Outlet_Location_Type desc

-- Metrics By Outlet Type
select Outlet_Type,
	cast(sum(Total_Sales) as decimal(10,2)) As Total_Sales ,
	cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) As decimal(10,2)) As Percen_tage,
	cast(avg(Total_Sales) as decimal(10,2)) As Average_Sales, 
	count(*) as Total_Item_Bought,
	cast(avg(Rating) as decimal(10,2)) As Average_Rating
from BlinkIT_Data
group by Outlet_Type
order by Outlet_Type desc
