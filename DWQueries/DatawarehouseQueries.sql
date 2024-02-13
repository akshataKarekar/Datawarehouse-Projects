--Find the count of rows in the table FactBilling

select count(*) from public."FactBilling";

--Create a simple MQT named avg_customer_bill with fields customerid and averagebillamount.

CREATE MATERIALIZED VIEW  avg_customer_bill (customerid, averagebillamount) AS
(select customerid, avg(billedamount)
from public."FactBilling"
group by customerid
);

--Refresh the newly created MQT

REFRESH MATERIALIZED VIEW avg_customer_bill;

--Using the newly created MQT find the customers whose average billing is more than 11000


select * from avg_customer_bill where averagebillamount > 11000;


--Write a query using grouping sets

select year,category, sum(billedamount) as totalbilledamount
from "FactBilling"
left join "DimCustomer"
on "FactBilling".customerid = "DimCustomer".customerid
left join "DimMonth"
on "FactBilling".monthid="DimMonth".monthid
group by grouping sets(year,category);


--Write a query using rollup

select year,category, sum(billedamount) as totalbilledamount
from "FactBilling"
left join "DimCustomer"
on "FactBilling".customerid = "DimCustomer".customerid
left join "DimMonth"
on "FactBilling".monthid="DimMonth".monthid
group by rollup(year,category)
order by year, category;


--Write a query using cube

select year,category, sum(billedamount) as totalbilledamount
from "FactBilling"
left join "DimCustomer"
on "FactBilling".customerid = "DimCustomer".customerid
left join "DimMonth"
on "FactBilling".monthid="DimMonth".monthid
group by cube(year,category)
order by year, category;


--Create a Materialized Query Table(MQT)


CREATE MATERIALIZED VIEW countrystats (country, year, totalbilledamount) AS
(select country, year, sum(billedamount)
from "FactBilling"
left join "DimCustomer"
on "FactBilling".customerid = "DimCustomer".customerid
left join "DimMonth"
on "FactBilling".monthid="DimMonth".monthid
group by country,year);


--Query


select year, quartername, sum(billedamount) as totalbilledamount
from "FactBilling"
left join "DimCustomer"
on "FactBilling".customerid = "DimCustomer".customerid
left join "DimMonth"
on "FactBilling".monthid="DimMonth".monthid
group by grouping sets(year, quartername);

--Populate/refresh data into the MQT

REFRESH MATERIALIZED VIEW countrystats;
