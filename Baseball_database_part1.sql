#1.Using the Batting table, write a query that select the playerid, teamid, Hits (H), Home Runs (HR) and Walks (BB) for every player (Slide 15)
SELECT playerID, teamID, H as Hits, HR as "Home Runs", BB as Walks
FROM Batting

#2.	Modify the query you wrote in #1 to be sorted by playerid in descending order and the teamid in ascending order (Slide 34)
ORDER BY playerID desc,
	teamID
  
#3.	You decide you only want to know the playerid and each team that the plater played for. Modify your query in #2 to remove the column no longer wanted and only return 1 row for each playerid and team combination. You answer should remain sorted by playerid and teamid  
SELECT DISTINCT playerID, teamID
FROM Batting
ORDER BY playerID desc,
	teamID

#4. A friend is wonder how many bases a player “touches” in a given year. Write a query that calculates the bases touched for each player. You can calculate this by multiplying B2 *2, B3*3 and HR *4 and then adding all these calculated values to the values in BB and H and rename the calculated column Total_Bases_Touched. Your output should include the playerid, yearid and teamid in addition to the Totl_Bases_Touched column
SELECT playerID, yearID, teamID, ((B2*2)+(B3*3)+(HR*4)+BB+H) as Total_Bases_Touched
FROM Batting

#5.	Since we are in the New York area, we’re only interested in the NY teams, Modify the query you wrote for #4  by adding a where statement that only select the 2 NY teams, the Yankees and the Mets  (Teamid = NYA or NYN) so that only the information for the NY teams is returned.
WHERE teamID = 'NYA' or teamID = 'NYN'

#6.	Your curious how a players “bases touched “ compares to the teams for a given year. You do this by adding the Teams table to the query and calculating a Teams_Bases_Touched columns using the same formula for the H, HR, BB, B2 and B3 columns in the teams table. You also want to know the percentage of the teams touched bases each payer was responsible for. Calculated the Touched_% column and use the FORMAT statement for show the results as a % and with commas. Your query should return 6,820 rows
SELECT Batting.playerID, Batting.yearID, Batting.teamID,((Batting.B2*2)+(Batting.B3*3)+(Batting.HR*4)+Batting.BB+Batting.H) as Total_Bases_Touched, 
	FORMAT(((Teams.B2*2)+(Teams.B3*3)+(Teams.HR*4)+Teams.BB+Teams.H),'#,##0') as Teams_Bases_touched, 
	FORMAT(((((Batting.B2*2)+(Batting.B3*3)+(Batting.HR*4)+Batting.BB+Batting.H)*1.0)/(((Teams.B2*2)+(Teams.B3*3)+(Teams.HR*4)+Teams.BB+Teams.H)))*100, 'N2')+'%' as Touched_Percentage
FROM Batting, Teams
WHERE Batting.yearID = Teams.yearID and
	Batting.teamID = Teams.teamID and
	Teams.teamID in ('NYA', 'NYN')
ORDER BY Batting.yearID, playerID

#7.	Rewrite the query in #6 using a JOIN parameter in the from statement. The results will be the same. Your query should return 6,820 rows
SELECT Batting.playerID, Batting.yearID, Batting.teamID,((Batting.B2*2)+(Batting.B3*3)+(Batting.HR*4)+Batting.BB+Batting.H) as Total_Bases_Touched, 
	FORMAT(((Teams.B2*2)+(Teams.B3*3)+(Teams.HR*4)+Teams.BB+Teams.H),'#,##0') as Teams_Bases_touched, 
	FORMAT(((((Batting.B2*2)+(Batting.B3*3)+(Batting.HR*4)+Batting.BB+Batting.H)*1.0)/(((Teams.B2*2)+(Teams.B3*3)+(Teams.HR*4)+Teams.BB+Teams.H)))*100, 'N2')+'%' as Touched_Percentage
FROM Batting JOIN
Teams on Batting.yearID = Teams.yearID
WHERE Batting.teamID = Teams.teamID and
	Teams.teamID in ('NYA', 'NYN')
ORDER BY Batting.yearID, playerID

#8.	Using the PEOPLE table, write a query lists the first, last and given name for all players that use their initials as their first name (Hint: nameFirst contains at least 1 period(.). See slide 32) Also, concatenate the nameGiven, nameFirst and nameLast into an additional  single column called Full Name putting the nameFirst in parenthesis. For example: James (Jim) Markulic)
SELECT playerID, (nameGiven+' ( '+ nameFirst+' ) '+ nameLast) as Full_Name
FROM People 
WHERE nameFirst LIKE '%.%'
  
#9.	Using a Between clause in the where statement write a query that uses the Batting table and shows the playerid, yearid, AB, batting_average (calculated by dividing H by AB). The batting averages you are interested in are between .1 and .4999.  The batting_average needs to be formatted with 4 digits behind the decimal point. The results need to be sorted by batting_average in descending order and then playerid and yearid in ascending order 
SELECT playerID, yearID, AB as At_Bats, 
	FORMAT((H*1.0/AB), '0.0000') as batting_average
FROM Batting
WHERE AB != 0 and 
	(H*1.0/AB) BETWEEN 0.1 and 0.4999
ORDER BY batting_average DESC,
	playeriD, yearID
  
#10.	Now you decide to pull all the information you’ve developed together. Write a query that shows the Total_bases_touched in #5, the batting_averages from #9 and the player’s name as formatted in #8. You also want to add the teamid and the team’s batting average for the year. As a final piece of information, calculate the difference between the team and player batting average. Additionally, rename the tables to only use the first letter of the table in the select and where statement. This saves a considerable amount of typing and makes the query easier to read.
SELECT P.playerID, (nameGiven+' ( '+ nameFirst+' ) '+ nameLast) as Full_Name, B.yearID, B.teamID, 
	((B.B2*2)+(B.B3*3)+(B.HR*4)+B.BB+B.H) as Total_Bases_Touched, 
	FORMAT((B.H*1.0/B.AB), '0.0000') as batting_average, 
	FORMAT((T.H*1.0/T.AB), '0.0000') as team_batting_average, 
	FORMAT(((B.H*1.0/B.AB)-(T.H*1.0/T.AB)), '0.0000') as batting_average_difference
FROM Batting as B, People as P, Teams as T
WHERE B.AB != 0 and T.AB !=0 and
	B.yearID = T.yearID and
	B.teamID = T.teamID and
	B.playerID = P.playerID and
	(B.H*1.0/B.AB) BETWEEN 0.1 and 0.4999
ORDER BY batting_average DESC,
	playeriD, yearID
