/*Database*/ 

use SQL_Project_Advance;

/*Importing the csv files which is extraxt and cleaned by Python*/
select * from access_to_rural;
select * from access_to_urban;
select * from access_to_world;
select * from production_by_nuclear;
select * from production_by_oil;
select * from production_by_renewable;
select * from transmission_distribution_losses;

/*Importing the csv files which is Metadata of */

select * from Metadata_Country;

/*Altering the Data where dropping unwanted columns*/

alter table Metadata_Country drop column SpecialNotes ,  TableName, column6

/*Q1 Comparison of access to electricity post 2000s in different countries*/

select Country_Name,avg(d_point) as avg_prec_consump from access_to_world 
where YEAR > 2000 
group by Country_Name ,Indicator_Name

/*
Q2 A chart to present the production of electricity across different sources (nuclear, oil, etc.) as a function of time
*/



select Region ,max(a.d_point) as 'Max_Transmission_loss_%_Total' 
from transmission_distribution_losses as a inner join Metadata_Country as b on a.Country_Code = b.Country_Code 
inner join access_to_rural as c on a.Country_Code = b.Country_Code 
where Region is not null
group by Region 


/*
Q3 Present a way to compare every country’s performance with respect to world average for every year. As in, 
if someone wants to check how is the accessibility of electricity in India 
in 2006 as compared to average access of the world to electricity
*/

select Country_Name,Country_Code, Indicator_Name, Year , d_point as 'Country_%_Access_Elecricity' , 
avg(d_point)  over (partition by Year) as Worlds__Access_Avg_Per_year 
from access_to_world    


/*
Q4 A chart to depict the increase in count of country with greater than 75% electricity access in rural areas across different year.
For example, what was the count of countries having ≥75% rural electricity access in 2000 as compared to 2010. 
*/

select  Year , count(Country_Name) as Count_of_Country from access_to_rural 
where d_point >= 75 group by Year

/*
Q5 Define a way/KPI to present the evolution of nuclear power presence grouped by Region and IncomeGroup. 
How was the nuclear power generation in the region of Europe & Central Asia as compared to Sub-Saharan Africa. 
*/

select Region ,IncomeGroup ,Year,max(d_point) as 'Max_Production_%_Total' 
from production_by_nuclear as a inner join Metadata_Country as b on a.Country_Code = b.Country_Code 
where Region is not null
group by Region ,IncomeGroup,Year

/*
Q6 A chart to present the production of electricity across different sources (nuclear, oil, etc.) as a function of time
*/


select a.Year, AVG (a.d_point) as Nuclear_Production , avg (b.d_point) as Oil_Production from production_by_nuclear as a 
inner join production_by_oil as b on a.Year = b.Year
inner join  production_by_renewable as c on c.Year = b.Year 
group by a.Year
