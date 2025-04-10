-- Select All
SELECT *  FROM bellabeat.dailyactivity
;

-- Find number of users
SELECT COUNT( DISTINCT ID)  FROM bellabeat.dailyactivity
;
-- Average Calories burned Daily 
SELECT  AVG(Calories) 
FROM bellabeat.dailyactivity
;

-- Average Total Steps 
SELECT  AVG(TotalSteps) 
FROM bellabeat.dailyactivity
;

-- Combine for visual
SELECT COUNT( DISTINCT ID) as TotalUsers, AVG(Calories) as AverageCaloriesBurned, AVG(TotalSteps) as AverageTotalSteps   
FROM bellabeat.dailyactivity
;

-- Average Calories Daily in the month for users
SELECT ID,  AVG(Calories) as AverageCaloriesBurnedDaily
FROM bellabeat.dailyactivity
GROUP BY ID
ORDER BY AverageCaloriesBurnedDaily
;

-- Identifying the Day of the Week
SELECT ID, ActivityDate, dayname(ActivityDate) as DayofTheWeek
FROM bellabeat.dailyactivity
ORDER BY ID
;

-- Average Total Distance of User on Weekdays
WITH WEEKDAY AS
(
SELECT ID, ActivityDate, dayname(ActivityDate) as DayOfTheWeek, TotalDistance 
FROM bellabeat.dailyactivity
ORDER BY ID, ActivityDate
)
SELECT AVG(TotalDistance) as WeekdayDistance
FROM WEEKDAY

WHERE DayOfTheWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') 
;

-- Average Total Distance of User on Weekend
WITH WEEKEND AS
(
SELECT ID, ActivityDate, dayname(ActivityDate) as DayOfTheWeek, TotalDistance 
FROM bellabeat.dailyactivity
ORDER BY ID, ActivityDate
)
SELECT  AVG(TotalDistance) as WeekendDistance
-- SELECT *
FROM WEEKEND

WHERE DayOfTheWeek NOT IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') 
;

-- % Time spent Very/Fairly Active vs Light/Sedentary over full dataset
-- WITH TOTALTIME AS
-- (
SELECT 
SUM(VeryActiveMinutes) as TotalTimeVeryActive, SUM(FairlyActiveMinutes) as TotalTimeFairlyActive, 
  SUM(LightlyActiveMinutes) as TotalTimeLightlyctive, SUM(SedentaryMinutes) as TotalTimeSedentary
-- SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) + SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalMinutesTracked
FROM bellabeat.dailyactivity;

-- )
-- SELECT ID, VeryActiveMinutes, FairlyActiveMinutes, 
--   LightlyActiveMinutes, SedentaryMinutes, TotalMinutesTracked
-- FROM TOTALTIME
-- ;

-- % Time spent Very/Fairly Active vs Light/Sedentary over full dataset
WITH TOTALTIME AS
(
SELECT ID,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) as TotalMoreActiveMinutes,
  SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalLessActiveMinutes,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) + SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalMinutesTracked
FROM bellabeat.dailyactivity
GROUP BY ID
)
SELECT ID, TotalMoreActiveMinutes, TotalLessActiveMinutes, TotalMinutesTracked,
(TotalMoreActiveMinutes/TotalMinutesTracked)*100 as PercentTimeMoreActive,
(TotalLessActiveMinutes/TotalMinutesTracked)*100 as PercentTimeLessActive

FROM TOTALTIME
;

-- Temp Table % Time spent Very/Fairly Active vs Light/Sedentary 

DROP TABLE if EXISTS Weekday;
CREATE TEMPORARY TABLE Weekday
(
ID char(255),
ActivityDate date,
DayOfTheWeek char(255),
TotalMoreActiveMinutes numeric,
TotalLessActiveMinutes numeric,
TotalMinutesTracked numeric
)
;

INSERT INTO Weekday
SELECT ID, ActivityDate, dayname(ActivityDate) as DayOfTheWeek,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) as TotalMoreActiveMinutes,
  SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalLessActiveMinutes,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) + SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalMinutesTracked
FROM bellabeat.dailyactivity
GROUP BY ID, ActivityDate
-- ORDER BY ID, ActivityDate
;

--  See all the data
 Select *
From Weekday
;

-- Average Minutes Tracked by Day

Select  DayOfTheWeek,
AVG(TotalMinutesTracked) as AverageTotalMinutesTracked
From Weekday
GROUP BY DayOfTheWeek
ORDER BY AverageTotalMinutesTracked  ASC

;


-- % Time spent Very/Fairly Active vs Light/Sedentary on Weekdays 

Select 
AVG(TotalMoreActiveMinutes/TotalMinutesTracked)*100 as PercentTimeMoreActive,
AVG(TotalLessActiveMinutes/TotalMinutesTracked)*100 as PercentTimeLessActive
From Weekday
WHERE DayOfTheWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') 

;

-- % Time spent Very/Fairly Active vs Light/Sedentary on Weekends

Select 
AVG(TotalMoreActiveMinutes/TotalMinutesTracked)*100 as PercentTimeMoreActive,
AVG(TotalLessActiveMinutes/TotalMinutesTracked)*100 as PercentTimeLessActive
From Weekday
WHERE DayOfTheWeek IN ('Saturday', 'Sunday') 
;

--  See all the data for visual plus percents per day
 Select ID, ActivityDate, AVG(TotalMoreActiveMinutes/TotalMinutesTracked)*100 as PercentTimeMoreActive
From Weekday
GROUP BY ID, ActivityDate
;

-- Examining the habits of top 5 calorie burners vs lowest 5 
SELECT ID, SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) as TotalMoreActiveMinutes,
SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalLessActiveMinutes,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) + SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalMinutesTracked,
AVG(Calories) as AverageCaloriesBurnedDaily
FROM bellabeat.dailyactivity
GROUP BY ID
ORDER BY AverageCaloriesBurnedDaily DESC
Limit 5
;

SELECT ID, SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) as TotalMoreActiveMinutes,
SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalLessActiveMinutes,
SUM(VeryActiveMinutes) + SUM(FairlyActiveMinutes) + SUM(LightlyActiveMinutes)+SUM(SedentaryMinutes) as TotalMinutesTracked,
AVG(Calories) as AverageCaloriesBurnedDaily
FROM bellabeat.dailyactivity
GROUP BY ID
ORDER BY AverageCaloriesBurnedDaily ASC
Limit 5
;


