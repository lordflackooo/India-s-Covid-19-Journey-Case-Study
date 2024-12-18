create database covid;

use covid;

select * from icmrtestingdata;
select * from statewisedata;
select * from deathandrecovery;
select * from hospitalbeds;
select * from datewisepatients;
select * from agedistribution;

-- 1. the states, gender affected and the confirmed cases in their respective states where confirmed cases are more than 100.
select sr.State_UT, dr.Gender, sr.Confirmed
from statewisedata sr
join deathandrecovery dr on sr.State_UT = dr.State
where sr.Confirmed > 100;

-- 2. state that collected more than 1000 samples in a day
select icmr.sno, swd.State_UT, icmr.TotalSamplesTested
from icmrtestingdata icmr
join statewisedata swd on icmr.sno = swd.sno
where icmr.TotalSamplesTested > 1000;

-- 3. the patient status in each state from the death_and_recovery table
select t1.State, t1.Patient_status,t2.City,t2.Age
from deathandrecovery t1
join deathandrecovery t2 on t1.State = t2.State
order by t1.State;

-- 4 the hospital beds along with their location where patients have recovered from covid-19 and those beds are made available to the needy patients waiting in the queue to get admitted.
SELECT DISTINCT dr.Patient_status, hb.State, hb.Beds_Available
FROM deathandrecovery dr
JOIN hospitalbeds hb ON dr.State = hb.State
WHERE dr.Patient_status = 'Recovered' AND hb.Beds_Available > 0;

-- 5. The total number of people in assam who have recovered
select count(*) as TotalRecovered
from deathandrecovery
where State = 'Assam' and Patient_status = 'Recovered';

-- 6. the state, hospitals and beds available where population beds and hospitals available are more than 1000.
select State, Hospitals_Available,Beds_Available
from hospitalbeds
where Hospitals_Available > 1000 And Beds_Available >1000;

--7. States where active cases are less than 50
select State_UT
from statewisedata
where Active < 50;

-- Dates that are associated with he availability of beds, as captured in the 'datewisepatients' and 'hospitalbeds' 
--SELECT Date
--FROM (
--    SELECT Date
--    FROM datewisepatients
--    UNION
--    SELECT Last_updad_time as Date
--    FROM statewisedata
--) AS CombinedDates;


-- 8. the details of the number of samples tested across each timestamp from the 'icmrtestingdata' table
select UpdatedTimeStamp,TotalSamplesTested
from icmrtestingdata;

-- 9. The number male and female who have recovered
select Gender, COUNT(*) as RecoveryCount
from deathandrecovery
where Patient_status ='Recovered'
group by Gender;

-- 10. List the states where the population is greater than the number of beds available in descending order of serial number
select hb.State
from hospitalbeds hb
join statewisedata swd on hb.State = swd.State_UT
where swd.Active > hb.Beds_Available
order by hb.Serial Desc;

-- 11. the total number of samples tested, total number of positive cases and the difference between 'TotalSamplesTested' and'TotalPostiveCases' columns from the icmrtestingdata' table
SELECT 
    SUM(TotalSamplesTested) AS TotalSamplesTested,
    SUM(TotalPositiveCases) AS TotalPositiveCases,
    SUM(TotalSamplesTested) - SUM(TotalPositiveCases) AS Difference
FROM icmrtestingdata;

-- 12. the number of hospital beds available in each state,
SELECT State, SUM(Beds_Available) AS TotalBedsAvailable
FROM hospitalbeds
GROUP BY State;

-- 13. the total number of beds available in Tamil Nadu
SELECT SUM(Beds_Available) AS TotalBedsAvailable
FROM hospitalbeds
WHERE State = 'Tamil Nadu';

-- 14. Total number of beds available in India
SELECT SUM(Beds_Available) AS TotalBedsAvailable
FROM hospitalbeds;

-- 15. the distinct values of 'TotalSamplesTested', 'TotalPositiveCases', and 'UpdatedTimeStamp' from the 'icmrtestingdata' table
SELECT DISTINCT TotalSamplesTested, TotalPositiveCases, UpdatedTimeStamp
FROM icmrtestingdata;

-- 16. the total confirmed cases in Maharashtra until 31st March
SELECT SUM(Confirmed) AS TotalConfirmedCases
FROM statewisedata
WHERE State_UT = 'Maharashtra' AND Last_updad_time <= '2022-03-31';

-- 17. the summing distribution of males and females aged 0 to 49 who have been impacted by COVID-19
SELECT 
    SUM(Male) AS TotalMales,
    SUM(Female) AS TotalFemales,
    SUM(Total) AS TotalImpacted
FROM agedistribution
WHERE Age_Group >= '0' AND Age_Group <= '49';

-- 18. the recovery rate among the states and display it along with the names of the states and the number of recovered & active cases.
SELECT
    swd.State_UT,
    swd.Recovered AS RecoveredCases,
    swd.Active AS ActiveCases,
    CASE
        WHEN (swd.Recovered + swd.Active) > 0 THEN ROUND((swd.Recovered / (swd.Recovered + swd.Active)) * 100, 2)
        ELSE 0
    END AS RecoveryRate
FROM statewisedata swd;

-- 19. the states along with the ratio of Beds available against the total population beds
SELECT
    State,
    Beds_Available,
    Population_beds,
    (Beds_Available / Population_beds) AS BedRatio
FROM
    hospitalbeds;


-- 20. the different patient statuses and the corresponding cities recorded in the 'death_and_recovery' table, after joining it with the 'statewisedata' table based on the matching State_UT values
SELECT DISTINCT dr.Patient_status, dr.City
FROM deathandrecovery dr
JOIN statewisedata swd ON dr.State = swd.State_UT
WHERE dr.Age IN (
    SELECT DISTINCT Age
    FROM deathandrecovery
);