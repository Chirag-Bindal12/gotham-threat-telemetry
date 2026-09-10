create database bat_comp;

use bat_comp;

show databases;
show tables;
select * from nodes;
select * from tactics;
select * from threat_incidents;
select * from rogue_gallery;


-- Batman Style SQL Crime Investigation Casebook
-- Use the attached CSV file in MySQL Workbench. Import the data and solve the SQL challenges
-- below.
-- Dataset Columns
-- CrimeID, CriminalName, Phone, CrimeType, Location, CrimeDate, CrimeTime, Amount
-- SQL Challenges


-- 1. Show all crimes ordered by CrimeDate.

select * from threat_incidents order by Timestamp;


-- 2. Find the criminal with the highest number of crimes.

select Alias,COUNT(Incident_Id) AS Total_Crimes_Committed from rogue_gallery join tactics on tactics.rogue_id=rogue_gallery.rogue_id group by Alias order by Total_Crimes_Committed
desc limit 1;


-- 3. Find total stolen amount by each criminal.

select Alias,sum(Estimated_Property_Loss_USD) as Total from threat_incidents join rogue_gallery on Primary_Associated_Node_Id=Detected_By_Node_Id
group by Alias order by total desc;


-- 4. Find the top 5 highest-value crimes.

select Alias,sum(known_bounty_usd) as Total from rogue_gallery group by Alias order by sum(known_bounty_usd) desc limit 5;

-- 5. Count crimes by location (Using true threat logs).

SELECT District,COUNT(Incident_Id) AS Total_Crime FROM threat_incidents GROUP BY District ORDER BY Total_Crime DESC;

-- 6. Count crimes by crime type.

select Incident_Type,count(*) from threat_incidents group by Incident_Type order by count(*) desc;


-- 7. Find criminals involved in more than 5 crimes.

select Alias,count(alias) as "Criminal Name" from rogue_gallery group by alias having count(alias)>5;

-- 8. Find average crime amount by crime type.

select Incident_type,avg(known_bounty_usd) as Crime_Amount from rogue_gallery join threat_incidents on Primary_Associated_Node_Id=Detected_By_Node_Id group by Incident_type order by avg(known_bounty_usd) desc;

-- 9. Find crimes committed after 8 PM.

select * from threat_incidents where Hour(Timestamp)>=20;
select * from threat_incidents where Hour(Timestamp)>="20:00:00";

-- 10. Find total amount stolen in each location.


select district,sum(Estimated_Property_Loss_Usd) as Amount_Stolen from threat_incidents group by district;

-- 11. Rank criminals by total stolen amount using a window function.


select alias,sum(estimated_property_loss_usd) as Stolen_Amount,dense_rank() over(order by sum(estimated_property_loss_usd) desc) as Total from rogue_gallery join threat_incidents on Primary_Associated_Node_Id=Detected_By_Node_Id group by alias;


-- 11. Rank criminals by total stolen amount using a window function.
select Alias,sum(Estimated_Property_Loss_Usd) as Aggregated_Loss_USD,dense_rank() over(order by sum(Estimated_Property_Loss_Usd) desc) as Criminal_Loss_Rank 
from rogue_gallery join tactics ON rogue_gallery.Rogue_Id=tactics.Rogue_Id join threat_incidents on threat_incidents.Incident_Id=tactics.Incident_Id 
group by Alias;

-- 12. Find the most active criminal each month.

select Alias,date_format(Timestamp,'%M') as Month,count(*) as Crimes from rogue_gallery join threat_incidents on Primary_Associated_Node_Id=Detected_By_Node_Id GROUP BY Month, Alias order by crimes desc;


-- 13. Find the percentage contribution of each criminal to total crime amount

select Alias,sum(estimated_property_loss_usd) as Total,percent_rank() over(order by sum(estimated_property_loss_usd)) as Loss_Contribution from rogue_gallery join threat_incidents on Primary_Associated_Node_Id=Detected_By_Node_Id group by Alias order by loss_contribution desc;


-- 14. Find the total property damage caused by each villain's incidents, but only for villains whose individual danger_index_score is strictly above 7.5.
-- Show the alias, danger_index_score, and the total_damage. Sort the list so the highest total damage appears at the top.

select Alias,Danger_Index_Score,sum(Estimated_Property_Loss_Usd) AS Total_Damage from rogue_gallery join tactics on rogue_gallery.Rogue_Id=tactics.Rogue_Id join threat_incidents 
on tactics.Incident_Id=threat_incidents.Incident_Id where rogue_gallery.Danger_Index_Score > 7.5 group by Alias, Danger_Index_Score order by Total_Damage desc;


-- 15. For each unique bat_suit_used, calculate the total number of batarangs deployed and the average tactical success rate. Only display rows where the suit was used in an
-- intervention where the incident response status was completely resolved by Batman ('RESOLVED_BY_BATMAN').

select Bat_suit_used,sum(batarangs_deployed) as Total_Batarangs_Deployed,avg(tactical_success_rate) as Success_Rate from tactics join threat_incidents on tactics.Incident_Id= threat_incidents.Incident_id where response_status='RESOLVED_BY_BATMAN' group by bat_suit_used;

-- 16. Write a query that displays every single incident's incident_id, district, and estimated_property_loss_usd. Next to each row, use a window function to show the average property 
-- loss of that specific district so a supervisor can instantly see if a particular crime was above or below its district's average.

select Incident_ID,District,Estimated_Property_Loss_USD,avg(Estimated_Property_Loss_USD) over(partition by District) as Average_Loss from threat_incidents ;

-- 17. Find the names of all computer nodes (node_name) that are currently marked as 'DEGRADED'
-- AND have detected an incident with a threat_priority of either 'HIGH' or 'CRITICAL'. Display the
-- node_name, its encryption_level, and the incident_type it picked up.

select Node_Name,Encryption_Level,Incident_Type,Threat_Priority from nodes join threat_incidents on Node_ID=Detected_By_Node_Id where nodes.Operational_Status="Degraded" and threat_incidents.threat_priority in ("High","Critical");


-- 18. Write a production-grade query that extracts every incident's Incident_ID, District, and Estimated_Property_Loss_USD from the threat_incidents table. Next to each individual
-- incident row, append a column showing the absolute mathematical deviation between that specific incident's loss value and the moving average loss of its designated district.
-- To prevent outlier skewing, filter the output so it only displays records where the incident's loss value strictly exceeds the overall average loss calculated across the entire 
-- city of Gotham.

select * from (select Incident_ID,District,Estimated_Property_Loss_USD,(Estimated_Property_Loss_USD-avg(Estimated_Property_Loss_USD) over(partition by District)) as Deviation from threat_incidents) as Filtered_Data where Deviation>0;

-- 19. The Batcomputer needs to rank all identified profiles within the rogue_gallery based on their cumulative threat economic profile. Generate a dataset showing each criminal's Alias 
-- and their total aggregated bounty across all threat vectors. Next to each row, display a dense ranking position (1, 2, 2, 3...) based on their total bounty value in descending 
-- order,followed by a second ranking column showing their individual rank within their primary associate node group. You must display every granular incident row tracking back to
-- their operational deployment log, ensuring no row compression takes place.

select Alias,Known_Bounty_USD,Node_Name,dense_rank() over(order by Known_Bounty_USD desc) as "Dense_Rank",rank() over(order by Known_Bounty_USD desc)as "Rank" from rogue_gallery join nodes on Primary_Associated_Node_Id=Node_ID;

-- 20. Identify geographic districts where the collective financial damages stemming from threat incidents committed strictly between the hours of 20:00:00 (8:00 PM) and 04:00:00 
-- (4:00 AM) surpass the specific district's daylight average asset damage. The final output must only display the District name, the count of night incidents, and the total night
-- damages.The result grid must be explicitly sorted by the total nighttime damage metric in descending order.

SELECT District FROM threat_incidents WHERE HOUR(Timestamp) >= 20 OR HOUR(Timestamp) <= 4;

-- 21. Design a fully automated MySQL TRIGGER named after_incident_escalation bound to the threat_incidents table. Whenever a new incident record is inserted into the system, the trigger
-- must evaluate the incoming record's Threat_Priority. If the priority is flagged as 'CRITICAL' or 'HIGH', the trigger must automatically write a descriptive alert narrative into a
-- separate system log table called batcomputer_audit_logs, tracking the Incident_ID, the current system execution timestamp, and a structured notification string containing the
-- affected node ID.


create table batcomputer_audit_logs like threat_incidents;
alter table batcomputer_audit_logs drop column Incident_Type,drop column District,drop column Estimated_Property_Loss_Usd,drop column Response_Status;
select * from batcomputer_audit_logs;


delimiter //


create trigger After_Incident_Escalation
after insert on threat_incidents
for each row
begin
if new.threat_priority in ("High","Critical") then
insert into batcomputer_audit_logs values (new.incident_id,now(),new.detected_by_node_id,new.threat_priority);
end if;
end//

delimiter ;


INSERT INTO threat_incidents (Incident_ID, Timestamp,Incident_Type,District,Estimated_Property_Loss_USD,Detected_By_Node_Id,Threat_Priority,Response_Status)
VALUES ('INC-9999','2026-09-07 15:45:00','Cyber Hijack','Downtown',7500000,'N-101','Critical','ACTIVE_INVESTIGATION'),
('INC-1111','2026-09-07 16:00:00','Minor Shoplifting','The Narrows',150,'N-104','Low','RESOLVED_BY_GCPD');


-- 22. Develop a parameterized MySQL STORED PROCEDURE called ScanNodeVulnerabilities that accepts a single input variable: p_MaxAllowedLoss INT. When executed, the procedure must run an
-- inner complex query that joins the nodes asset grid against the threat_incidents log to identify all 'DEGRADED' or 'COMPROMISED' nodes whose average historical incident loss value
-- breaks past the input parameter ceiling. The procedure must dynamically output the compiled report array sorted by execution severity.


delimiter //
create procedure ScanNodeVulnerabilities(p_MaxAllowedLoss int)
begin
select Node_Name,Operational_Status,avg(Estimated_Property_Loss_Usd) from nodes join threat_incidents on Node_Id=Detected_by_node_id where Operational_Status="Degraded" group by Node_Name,Operational_Status having avg(Estimated_Property_Loss_Usd)>p_MaxAllowedLoss;
end;
//

delimiter ;

call ScanNodeVulnerabilities(4587222);


-- 23. Due to upgraded Wayne Enterprises encryption standards, you are tasked with executing a multi-stage structural schema update on the live nodes infrastructure table without 
-- resetting the data. Write a single structural execution script that achieves the following: 1. Appends a new tracking field named Backup_Node_ID (VARCHAR(50)) positioned 
-- immediately after the existing Node_ID field. 2. Modifies the data constraints of the Encryption_Level column, increasing its storage allocation threshold to VARCHAR(255) while
-- ensuring it defaults to 'AES_256_GCM'. 3. Drops a historical, deprecated status tracking column named Legacy_Status_Code.

alter table nodes add column Backup_Node_ID VARCHAR(50) after node_id,modify Encryption_Level VARCHAR(255) default 'AES_256_GCM';

-- alter table nodes drop column if exists Legacy_Status_Code - this wont work as the column already doesnt exists and alter forbids using if inside alter to drop the column.alter


-- 24. Find out which specific Districts in your database are suffering from repeating crime waves.Write a query that displays the District name and the total number of incidents 
-- logged in that area from the threat_incidents table. Filter the report so it only displays districts that have more than 1 crime logged, and sort the output so the most dangerous 
-- district appears right at the top.

select District,count(Incident_Type) as Total_Crimes from threat_incidents group by District having Total_Crimes>1 order by Total_Crimes desc;


-- 25. Write a query for the threat_incidents table that traces sector-wide activity sequences. For every incident record, display the Incident_Id, District, and Timestamp. Use an
-- advanced window configuration to extract the Incident_Type of the threat that occurred two incidents prior within that specific District, ordered by timestamp.
-- If no such record exists, default the value to 'FIRST_CONTACT'.

select Incident_Id,District,Timestamp,lag(Incident_Type,2,"First_Contact") over(partition by District order by Timestamp) as "WI_CO" from threat_incidents;

-- 26. For each intervention logged in the tactics table, display the Intervention_Id, Incident_Id, and Tactical_Success_Rate. Append an advanced tracking expression calculating the
-- mathematical difference between the current row's success rate and the success rate of the immediate next deployment across the entire grid. Ensure the dataset remains sorted 
-- dynamically by the primary identifier.

select Intervention_Id,threat_incidents.Incident_Id,Tactical_Success_Rate,(Tactical_Success_Rate)-lead(Tactical_Success_Rate) over() as "Difference" from threat_incidents
join tactics on tactics.Incident_Id=threat_incidents.Incident_Id;

-- 27. Analyze tactical velocity metrics across varying equipment footprints. Display every row's Incident_Id,Bat_Suit_Used, and Batarangs_Deployed from the tactics framework. Next to it,
-- compute a column tracking the historical maximum number of Batarangs deployed by that specific Bat-Suit in any prior incident up to the current entry timeline.

select Incident_Id,Bat_Suit_Used,Batarangs_Deployed,max(Batarangs_Deployed) over(partition by Bat_suit_Used order by Intervention_Id) as "MAX_BATARANGS_DEPLOYED" from tactics;

-- 28. Isolate immediate threat behaviors by comparing current financial anomalies to historical high-water marks.Extract the Incident_Id, District, and Estimated_Property_Loss_Usd
-- from threat_incidents. Compute a column showing the highest loss value observed in that exact district prior to or including the current incident timestamp

select Incident_Id,District,Estimated_Property_Loss_Usd,max(Estimated_Property_Loss_Usd) over(partition by District order by Timestamp) as "MAX_LOSS" from threat_incidents;


-- 29. Write a query tracking shifts in tactical precision across consecutive operations. For every row in tactics, extract the Tactical_Success_Rate. Append a column showing the average
-- success rate derived from a window containing the immediate preceding row, the current row, and the immediate following row. Restrict output rows where the raw rate drifts by more
-- than 15 units from this boundary average.

select * from (select Bat_Suit_Used,Tactical_Success_Rate,round(avg(Tactical_Success_Rate) over(order by Intervention_Id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING),2) as "Success_Rate" from tactics) as ANSWER WHERE ABS(Tactical_Success_Rate - Success_Rate) > 15.0;


-- 30. Generate an analytical asset layout mapping the rogue_gallery entries into variable risk evaluation categories without matching explicit structural keys. Create a virtual
-- evaluation range framework containing categories: 'Low Risk' ($0-$1.5M), 'Moderate Risk' ($1.5M-$3M), and 'Extreme Threat' (Above $3M). Join your rogue dataset against this
-- framework using an inequality conditional expression to classify every target asset.

select Alias,Real_Name,Known_Bounty_USD,case when Known_Bounty_USD<=1500000 then"LOW RISK" when Known_Bounty_USD<=3000000 then "MODERATE RISK" else "EXTREMEM THREAT" end as 
"DANGER" from rogue_gallery order by Known_Bounty_USD desc;

-- 31. Isolate municipal infrastructure exposures using non-equi join ranges. Map every historical incident's Estimated_Property_Loss_Usd against an external reference bracket tracking
-- target operational thresholds: Tier A ($0-$1M), Tier B ($1M-$4M), and Tier C (Above $4M). Display the absolute distribution metrics, showing total incidents logged within each
-- calculated cost bracket.

select case when Estimated_Property_Loss_Usd<=1000000 then "TIER A" when Estimated_Property_Loss_Usd<=4000000 then "TIER B" else "TIER C" end as "Operational Thresholds",count(*)
as "TOTAL_INCIDENTS" from threat_incidents group by case when Estimated_Property_Loss_Usd<=1000000 then "TIER A" when Estimated_Property_Loss_Usd<=4000000 then "TIER B" else "TIER C" end;


select case when Estimated_Property_Loss_Usd<=1000000 then "TIER A" when Estimated_Property_Loss_Usd<=4000000 then "TIER B" else "TIER C" end as "Operational Thresholds",count("Operational Thresholds")
as "TOTAL_INCIDENTS" from threat_incidents group by case when Estimated_Property_Loss_Usd<=1000000 then "TIER A" when Estimated_Property_Loss_Usd<=4000000 then "TIER B" else "TIER C" end;


-- 32. Write a query evaluating threat intersections across distinct geographical sectors. Join the nodes master table against the threat_incidents table using a non-equi condition where
-- the incident occurred in a district that does not directly match the node's sector, but where the incident's loss exceeds the node's baseline threat limit ($2,000,000). Display
-- the mismatched node and incident intersection grids.

select Node_ID,Node_Name,Sector,Incident_ID,District,Incident_Type,Estimated_Property_Loss_Usd from nodes join threat_incidents on nodes.sector!=threat_incidents.district where Estimated_Property_Loss_Usd>2000000
ORDER BY Estimated_Property_Loss_Usd DESC;


-- 33. Classify the active combat profiles of villains by cross-referencing the Danger_Index_Score in the rogue_gallery against a grading scale: Standard (0-6.0), High Alert (6.1-8.5),
-- and Omega Level (8.6-10.0).Output a clean, distinct dataset containing the Rogue_Id, Alias, Danger_Index_Score, and assigned tactical priority classification tag.

select Rogue_Id,Alias,Danger_Index_Score,case when Danger_Index_Score<=6.0 then "STANDARD" when Danger_Index_Score<=8.5 then "HIGH ALERT" else "OMEGA LEVEL" end as
"Tactical Priority Classification Tag" from rogue_gallery;

-- 34. Write an enterprise query that maps every item in threat_incidents to a variable security response protocol based on financial impact parameters. Join the dataset against a
-- security matrix where the response status tier scales based on whether the damage falls within dynamic upper and lower financial control boundaries. Display the Incident_Id
-- alongside the calculated response bracket metadata.


select Incident_ID,Estimated_Property_Loss_Usd,case when Estimated_Property_Loss_Usd<=1000000 then "ROUTINE LEVEL" when Estimated_Property_Loss_Usd<=5000000 then "ROUTINE LEVEL" else "OMEGA LEVEL" end as 
"Calculated_Response_Bracket_Metadata" from threat_incidents;


-- 35. Build a production-grade summary cross-tabulation report showcasing structural network encryption strengths.Transform vertical rows into structured horizontal columns. The
-- final output must show the Sector name asdistinct rows, and create three dynamic summary count columns: Quantum_SHA_Count, AES_256_Count, and Legacy_DES_Count based on conditions
-- inside he aggregation expressions.

SELECT Sector,sum(CASE WHEN Encryption_Level = 'Quantum-SHA' THEN 1 ELSE 0 END) AS Quantum_SHA_Count,sum(CASE WHEN Encryption_Level = 'AES-256' THEN 1 ELSE 0 END) AS AES_256_Count,
SUM(CASE WHEN Encryption_Level = 'Legacy-DES' THEN 1 ELSE 0 END) AS Legacy_DES_Count FROM nodes GROUP BY Sector;


-- 36. Generate a clean matrix overview summarizing municipal stability. Write a single analytical expression that displays the District name as the row key, and outputs three horizontal
-- columns tracking the exact number of 'CRITICAL', 'HIGH', and 'MEDIUM' priority threats recorded in that area. Sort the final output by the critical metric in descending order.

select District,sum(case when threat_priority="Critical" then 1 else 0 end) AS "CRITICAL",sum(case when threat_priority="High" then 1 else 0 end)as "HIGH",sum(case when 
threat_priority="Medium" then 1 else 0 end)as "MEDIUM" from threat_incidents group by district;


-- 37. Analyze the economic efficiency of Batman's armory by aggregating operational damage footprints conditionally.For each distinct Bat_Suit_Used in the tactics log, compute the total
-- property damage caused by incidents where the success rate was above 90%, and contrast it next to the total property damage caused where the success rate fell below 90% in a
-- single row layout.


select Bat_Suit_Used,sum(Estimated_Property_Loss_Usd) as Property_Damage from tactics join threat_incidents on tactics.incident_id=threat_incidents.incident_id where Tactical_Success_Rate<90 group by bat_suit_used;


-- 38. Construct a system control table that counts node infrastructure assets dynamically. The report must display the unique Encryption_Level values as rows, and provide dedicated
-- pivot columns counting how many matching nodes are currently marked 'ONLINE', 'DEGRADED', or 'OFFLINE' within the network grid.

select Encryption_Level,sum(case when Operational_Status="Online" then 1 else 0 end) AS "Online",sum(case when Operational_Status="Degraded" then 1 else 0 end)as "Degraded",
sum(case when Operational_Status="Offline" then 1 else 0 end) as "Offline" from nodes group by Encryption_Level;


-- 39. Write a query evaluating seasonal damage variations across the calendar timeline. Break down incidents conditionally by isolating their extracted timestamp metrics into specific
-- time blocks. Generate columns tracking total financial losses recorded during the first half of the day versus the second half of the day, grouped cleanly by District fields.

select District,sum(case when hour(timestamp)<12 then Estimated_Property_Loss_Usd  else 0 end) AS "First Half",sum(case when hour(timestamp)>=12 then Estimated_Property_Loss_Usd
else 0 end) AS "Second Half" from threat_incidents group by district;

-- 40. Calculate a smoothed performance metric for tactical drops. For every entry in the tactics table, display the Intervention_Id, Incident_Id, and Tactical_Success_Rate. Append a
-- column tracking a centered moving average that computes the mathematical mean of the immediate previous row, the current row, and the immediate subsequent row using explicit
-- physical window boundary definitions.

select Intervention_ID,Incident_ID,Tactical_Success_Rate,round(avg(Tactical_Success_Rate) over(rows between 1 preceding and 1 following),2) as "Centered Moving Avg" from tactics;


-- 41. Track the real-time financial degradation profile of urban sectors over time. Generate a query for the threat_incidents table that displays the Incident_Id, District, and
-- Estimated_Property_Loss_Usd.Append an unbounded rolling accumulator column that calculates the total running financial loss from the first logged incident up to the current row,
-- partitioned explicitly by District

select Incident_Id,District,Estimated_Property_Loss_Usd,sum(Estimated_Property_Loss_Usd) over(partition by district order by incident_id) as "Total Running Financial Loss" from
threat_incidents;

select Incident_Id,District,Estimated_Property_Loss_Usd,sum(Estimated_Property_Loss_Usd) over(partition by district order by incident_id rows between UNBOUNDED PRECEDING AND 
CURRENT ROW) as "Total Running Financial Loss" from threat_incidents;


-- 42. Monitor logistical material usage curves across successive combat drops. For every row in the tactics table, show the Intervention_Id, Bat_Suit_Used, and Batarangs_Deployed.
-- Compute a custom bounded running total tracking the cumulative sum of Batarangs used across a sliding frame restricted to the last two historical deployments and the current entry.

select Intervention_Id,Bat_Suit_Used,Batarangs_Deployed,sum(Batarangs_Deployed) over(rows between 2 preceding and current row) as "TOTAL BATARANGS DEPLOYED" from tactics ;


-- 43. Write a query evaluating volatility trends in system network integrity. For every record in the nodes architecture table, track the operational uptime profiles by outputting a
-- running calculation showing the minimum and maximum encryption thresholds observed across a sliding window frame encompassing the current row and the immediate next two rows.

-- 43. Write a query evaluating volatility trends in system network integrity using an inline subquery.


SELECT Answer.Node_ID,Answer.Node_Name,Answer.Encryption_Level,min(Answer.Security_Weight_Score) over(order by Answer.Node_ID rows between current row and 2 following) as
"Minimum Encryption Threshold",max(Answer.Security_Weight_Score) over(order by Answer.Node_ID rows between current row and 2 following) AS "Maximum Encryption Threshold" from
(select Node_ID, Node_Name,Encryption_Level,case when Encryption_Level = 'Legacy-DES'  then 1 when Encryption_Level = 'AES-256' then 5 when Encryption_Level = 'RSA-4096'
then 8 when Encryption_Level = 'Quantum-SHA' then 10 else 0 end as Security_Weight_Score from nodes) as Answer;



-- 44. Construct an analytical flag targeting statistical spikes in asset destruction. For every incident row, calculate a moving 3-row historical loss baseline average. Create a 
-- conditional statement that flags the current incident row as a 'COST_ANOMALY' if its specific Estimated_Property_Loss_Usd breaks past the moving baseline value by more than 50%.

select *,case when Estimated_Property_Loss_USD>(1.5*Moving_Baseline_AVG) then "COST_ANOMALY" else "STANDARD_VARIANCE" end as "Status" from (select Incident_Id,District,
Estimated_Property_Loss_USD,avg(Estimated_Property_Loss_USD) over(rows between 2 preceding and current row) as "Moving_Baseline_AVG" from threat_incidents) as ANSWER;


-- 45. Identify high-impact security breaches using advanced relational nesting logic. Write a query that extracts all fields from the threat_incidents table where the individual
-- incident's loss value strictly exceeds the calculated average property loss of its specific designated district. You are strictly forbidden from utilizing any window
-- partition syntax to achieve this output.

select * from threat_incidents join (select District,avg(Estimated_Property_Loss_Usd) as "AVG_LOSS" from threat_incidents group by district) as ANSWER on
threat_incidents.district=answer.district where Estimated_Property_Loss_Usd>avg_loss;


-- 46. Extract a secure profile tracking unaddressed infrastructure breaches. Write a correlated query identifying rows in threat_incidents that represent critical threat vectors,
-- ensuring the query checks for the existence of matching tactical deployments inside the tactics database log, and filters out any records that have already been marked resolved.

select tactics.Incident_Id,Incident_Type,District,Estimated_Property_Loss_Usd,Detected_By_Node_Id,Threat_Priority,Response_Status,Bat_Suit_Used,Batarangs_Deployed,Tactical_Success_Rate
 from threat_incidents join tactics on threat_incidents.incident_id=tactics.incident_id where threat_incidents.response_status not like "%resolved%" and threat_priority="critical";
 
 
 
select ti.Incident_Id,ti.Incident_Type,ti.District,ti.Estimated_Property_Loss_Usd,ti.Threat_Priority from threat_incidents ti where ti.Threat_Priority = 'CRITICAL' and
ti.Response_Status not like '%resolved%' and exists (select 1 from tactics t where t.Incident_Id = ti.Incident_Id) order by ti.Estimated_Property_Loss_Usd desc;

      
-- 47. Verify system architecture integrity across disparate databases. Write a deep subquery that evaluates every profile inside the rogue_gallery map. Extract records where the rogue
-- asset's Primary_Associated_Node_Id points to a node whose specific individual Encryption_Level is mathematically lower than the average encryption safety threshold calculated
-- cross the entire city infrastructure network.

select * from(select Rogue_Id, Alias, Real_Name, Known_Bounty_Usd, Primary_Associated_Node_Id, Danger_Index_Score,Encryption_Level,case when  Encryption_Level="Legacy-DES" then 1 
when Encryption_Level="AES-256" then 5 when Encryption_Level="RSA-4096" then 8 else 10 end as Encryption_Power from nodes join rogue_gallery on Primary_Associated_Node_Id=Node_Id)
as ANSWER where Encryption_Power<(select avg(Encryption_Power) from (select *,case when Encryption_Level="Legacy-DES" then 1 when Encryption_Level="AES-256" then 5 when 
Encryption_Level="RSA-4096" then 8 else 10 end as Encryption_Power from nodes) as ANSWER);


-- 48. Write an advanced analytics expression that isolates top-tier threat matrices. Extract the Incident_Id, District,and Detected_By_Node_Id from the threat_incidents table, but 
-- restrict the output dataset rows so that it only retains records that were detected by a network node currently associated with a villain whose Danger_Index_Score sits at the 
-- absolute peak value for that node group.

select Incident_ID,District,Detected_By_Node_Id,Danger_Index_Score,dense_rank() over(Partition by Detected_By_Node_Id order by Danger_Index_Score desc) as Ranking from
threat_incidents join rogue_gallery on Detected_By_Node_Id=Primary_Associated_Node_Id join nodes on Node_Id=Primary_Associated_Node_Id;

-- 49. Identify structural bottlenecks by writing an inner-to-outer correlated execution script. Filter and return all rows from the master nodes infrastructure grid where the current
-- node is flagged with an operational breakdown status, provided that the node has historically logged more individual incidents than the aggregate average incident rate computed
-- for all other nodes running the same encryption level.

with answer as(select Node_id,Encryption_Level,count(incident_id) as Encryption_Count from nodes join threat_incidents on Detected_By_Node_Id = Node_Id group by
Node_id,Encryption_Level)
select * from nodes join answer on nodes.node_id=answer.node_id where nodes.Operational_Status in ("offline","degraded") and answer.Encryption_Count>(select avg(Encryption_Count) from answer);


-- 50. Construct the final, master forensic validation report designed to capture cross-database security anomalies.Write a deep relational query that evaluates every active data row
-- across all four primary tables (nodes,rogue_gallery, threat_incidents, tactics). The script must isolate and output records where an incident remains unresolved, the detecting
-- node is currently running on degraded or compromised legacy encryption protocols,and the active rogue element tied to that tracking node possesses a system danger score strictly
-- greater than the citywide average score threshold. Format the final output as a single, combined operational metadata audit grid.


select Node_Name,Sector,Encryption_Level,Operational_Status,ti.Incident_Id,Danger_Index_Score,Incident_Type,Threat_Priority,Response_Status,Tactical_Success_Rate,Alias 
from nodes as n join threat_incidents as ti on node_id=Detected_By_Node_Id join tactics as t on t.incident_id=ti.incident_id join rogue_gallery as r on r.rogue_id=t.rogue_id
where ti.response_status not like "%resolve%" and n.Operational_Status in ("Degraded","Offline") and r.danger_index_score>(select avg(danger_index_score) from rogue_gallery);

/*
===================================================================
 🏁 CHIRAG BINDAL — DATABASES ARE FINALLY DONE 🏁
===================================================================
 Architect: Chirag Bindal
 Status:    50 / 50 Master Queries Completed.
 Logic:     Correlated subqueries optimized, window analytics locked, 
            and the final boss query is running perfectly.
 Pipeline:  Pre-processed and cleaned the dataset a little bit 
            using Python & Pandas before importing it to the database.
===================================================================
 Batman might not sleep, but I definitely do. 
 The code compiles, the grids are green, and I am officially 
 closing the tab, shutting the laptop, and going to sleep.
===================================================================
*/
