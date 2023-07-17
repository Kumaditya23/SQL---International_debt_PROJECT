-- Table : international_debt
create table international_debt
(
	country_name varchar(50),
	country_code varchar(50),
	indicator_name text,
	indicator_code text,
	debt numeric
);

--copy over data from csv
copy international_debt from 'E:\international_debt.csv' delimiter ',' csv header

/*
1. The World Bank's international debt data 

it's not that we humans only take debts to manage our necessities. A country may also take debt to manage its 
economy. For example, infrastructure spending is one costly ingredient requires for a country's citizen to lead
comfortable lives. The World Bank is the organization that provide debt to countries.

In this notebook, we are going to analyze international debt data collected by The World Bank. The dataset
contains information about thr amount of debt (in USD) owed by devloping countries across several categories.
We are going to find the answer to questions like : 

1. What is the total amount of debt that is owed by the countries listed in the dataset?
2. Which country owns the maximunm amount of debt and what does that amount look like?
3. What is the average amount of debt owed by countries across different debt indicatords?

The first line of code connects us to the international_debt database where the table
international_debt is residing . let's first SELECT all of the columns from the international_debt table.
Also, We'll limit the output to the first ten rows to keep the output clean.
*/


select * from international_debt
limit 10


/*
2. Finding the number of distinct countries

From the first ten rows , we can see the amount of debt owned by Afganistan in the different debt indicators. But
we do not know the number of different countries we have on the table . Three are repetitions in the country 
names because a country is most likely to have debt in more than one debt indicator.

Without a countb of unique countries , we will not be able to perform our statistical analyses holistically. In this 
section, we are going to extract the number of unique countries present in the table. 
*/

select count(distinct(country_name)) as total_distinct_countries
from international_debt


/*
3. Finding out the distinct debt indicators

We can see there are a total of 124 countries present on the table . As we saw in the first section, there is a column 
called indicator_name that briefly specifies the purpose of taking the debt. Just beside that column , there is
another column called indicator_code which symbolizes the category of these debts. Knowing about these
various debt indicator will help us in the areas in whuch a country can possibly be indebted to.
*/

select distinct(indicator_code) as distinct_debt_indicators
from international_debt
group by distinct_debt_indicators
order by distinct_debt_indicators

/*
4. Totaling theamount of debt owed by the countries

As mentioned  earlier , the financial debt of a particular country represents its economic state. But if we were to
project this on an overall global scale, how will approach it ?

Let's switch gear from the debt indicators now and find out the total amount of debt (in USD) that is owed by
the different countries. This will give us a sense of how the overall economy of the entire world is holding up.
*/

select round(sum(debt)/1000000,2) as total_debt
from international_debt

/*
5. Country with the highest debt

'Human being can not comprehend very large or very small numbers. it would be useful for us to acknowledge
that facts' - Daniel Kahneman. That is more than 2=3 million USD , an amount which is really hard for us to 
fathom.

Now that we have the exact total of the amounts of debt owed by sevral countries , let's now find out the country
that owns the highest amount of debt along with the amount.Note that this debt is the sum of different debts 
owned by a country across several categories. This will help to understand more about the country in terms of its 
socio-economic scenarios. We can also find out the category in which the country owns itsb highest debt. But we 
will leave that for now.
*/

select country_name, round(sum(debt)/1000000,2)as total_debt
from international_debt
group by country_name
order by total_debt desc
limit 1

/*
6. Average amount of debt across indicators

so, it was CHINA . A more in -depth breakdown of china's debts can be found .

We now have a breif overview of the dataset and a few of its summary statistics . We already have an idea of the
different debt indicators in which the countries owe their debts. We can dig even further to find out on an 
avergae how much debt a country owes? This will give us a better sense of the distribution of the amount of debt
across different indicators.
*/

select indicator_code as debt_indicator,
round(avg(debt)/1000000,2) as average_debt,
indicator_name
from international_debt
group by debt_indicator, indicator_name
order by average_debt desc
limit 10

/*
7. The highest amount of principal repayments

We can see that the indicator DT.AMT.DLXF.CD tops the chart of average debt. This category includes
repayment of long term debts. Countries take on long-term debt to acquire immediate capital. More information
about this category can be found .

An interesting observation in the above finding is that there is a huge difference in the amounts of the indicators
after the second one. This indicates that the first two indicators might be the most severe categories in which the 
countries owe their debts.

We can investigate this a bit more so as to find out which country owes the highest amount of debt in
the category of long term debts (DT.AMT.DLXF.CD). Since not all te countries suffer from the same kind of
economic disturbances , this finding will allow us to understand that particular country's economic condition a bit 
more specifically.
*/

select country_name,
round(avg(debt)/1000000,2) as average_debt,
indicator_name,
indicator_code
from international_debt
group by country_name, indicator_name,indicator_code
having indicator_code = 'DT.AMT.DLXF.CD'
order by average_debt desc
limit 10


/*
8. The most common debt indicator

China has the highest amount of debt in the long-term debt (DT.AMT.DLXF.CD) category. This is verified by The
World Bank . It is often a good idea to verify our analysis like this since it validates that our investigations are correct.
We saw that long-term debt is the topmost category when it comes to the average amount of debt , But is it the 
most common indicator in which the countries owe their debt? Let's find that out .
*/

select indicator_name,
count(indicator_code) as indicator_count
from international_debt
group by indicator_code, indicator_name
order by indicator_count desc
limit 20


/*
9. Other viable debt issues and conclusion

There are total of six debt indicators in which all countries listed in our dataset have taken debt. The
indicator DT.AMT.DLXF.CD is also there in the list. So, this gives us a clue that all these countries are suffering
from a common economic issue.But that is not the end of the story , a part of the story rather.

Let's change tracks from debt_indicatornow and focus on the amount od debt again. Let's find out the 
maximum amount of debt across the indicator along with the respective country names. With this, we will be in a 
position to identify the other plausible economic issues a country might be going through. By the end of this 
section, we will have found out the debt indicators in which a country owes its highest debt.

In this notebook, we took a look at debt owed by countries the globe. We extracted a few summary 
statistics from the data and unraveled some interesting facts and figures . We also validated our finding to make 
sure the investigations are correct.
*/

select 
country_name ,
indicator_name,
max(debt) as maximum_debt
from international_debt
group by country_name, indicator_name
order by maximum_debt desc
limit 20