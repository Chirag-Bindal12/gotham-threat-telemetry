# 📡 GOTHAM THREAT INTELLIGENCE: THE BATCOMPUTER DATABASE

**50 SQL cases. 4 datasets. 1 analyst. Gotham has problems.**

> *"When the city has a crime problem, Batman investigates. When the database has a crime problem, I use SQL."*

Welcome to my **Gotham Threat Intelligence SQL Project**. This is a fictional crime and infrastructure investigation built around four interconnected datasets containing threat incidents, rogues, tactical deployments, and Gotham's network nodes.

The mission was simple: Clean the evidence ➔ load the database ➔ investigate Gotham ➔ try not to break anything.

---

## THE CASE

*   Gotham was having a very normal week.
*   There are criminals.
*   There are threats.
*   There are compromised systems.
*   There are millions of dollars in property damage.
*   And apparently, someone thought this was a good time to create 50 SQL questions.
*   So I opened the Batcomputer. Or, more accurately... **MySQL Workbench**.

---

## 1. CLEAN THE EVIDENCE & INGESTION

*   Before SQL could interrogate anything, the four CSV datasets needed some cleanup.
*   I used Python and Pandas to clean and standardize the datasets, including making the column names consistent and preparing the files for database ingestion.
*   Once the evidence was clean, I imported the datasets into MySQL using the **MySQL Workbench Table Data Import Wizard**.

```text
RAW CSV FILES ──► Python 🐍 ──► Data Import Wizard 🧙‍♂️ ──► Flawless MySQL Load 🗄️ ──► SQL INVESTIGATION 🦇
```
*Python handled the cleanup. The Wizard built the staging grids. MySQL handled the interrogation.*

---

## 2. THE FOUR TABLES

*   **`threat_incidents`** — The actual crime and threat logs. Tracks property losses, geographic districts, timestamps, threat priorities, response status, and the nodes that detected them.
*   **`rogue_gallery`** — The people responsible for making Gotham's statistics look terrible. Tracks criminal aliases, identities, known bounties, danger scores, and associated network nodes.
*   **`tactics`** — Everything Batman apparently did while solving the problem. Tracks interventions, bat-suits, batarangs deployed, and tactical success rates.
*   **`nodes`** — Gotham's infrastructure network. Tracks encryption levels, operational status, sectors, and node information.

---

## 3. WHY THIS PROJECT?

*   I wanted to move beyond writing isolated SQL queries and work with a database where the tables actually have relationships.
*   So instead of another employee-sales-orders dataset, I apparently decided that Gotham's criminals, compromised systems, tactical operations, and property damage were a better idea. Fair enough.
*   The result is a 50-question SQL investigation covering everything from basic queries to advanced SQL techniques.

---

## 4. THE INVESTIGATION STAGES

The SQL compilation contains 50 progressively challenging cases. It starts innocent. It does not stay innocent.

### ROUND 1 — BASIC INVESTIGATION
*   **Core SQL Syntax:** `"SELECT"` · `"WHERE"` · `"ORDER BY"` · `"COUNT()"` · `"SUM()"` · `"AVG()"` · `"GROUP BY"` · `"HAVING"`
*   **Investigation Focus:** Finding crime counts, identifying dangerous districts, categorizing threat types, calculating property damage, and investigating who is apparently responsible for Gotham's biggest mess. Pretty normal detective work. Just with more semicolons.

### ROUND 2 — FOLLOW THE CONNECTIONS
*   **Core SQL Syntax:** `"JOIN"` · `"ON"` · `"INNER JOIN"`
*   **Investigation Focus:** Connecting incidents, tactical deployments, rogues, and associated network nodes across multiple tables. This is where "JOIN" stopped being just a SQL keyword and started becoming a lifestyle.

### ROUND 3 — WINDOW FUNCTIONS
*   **Core SQL Syntax:** `"LAG()"` · `"LEAD()"` · `"RANK()"` · `"DENSE_RANK()"` · `"AVG() OVER()"` · `"SUM() OVER()"` · `"MAX() OVER()"`
*   **Investigation Focus:** Tracking historical activity, running totals, moving averages, rankings, and changes in tactical performance. Basically answering: *"What happened before this, what is happening now, and how bad is it becoming?"*

### ROUND 4 — ADVANCED INTERROGATION
*   **Core SQL Syntax:** `"CTEs"` · `"Subqueries"` · `"Correlated Subqueries"` · `"EXISTS"` · `"Conditional Aggregation"` · `"Non-equi Joins"` · `"Stored Procedures"` · `"Triggers"` · `"ALTER TABLE"`
*   **Investigation Focus:** Breaking complicated problems into smaller logical steps, comparing records against calculated benchmarks, checking whether related records exist, performing conditional analysis, modifying database structures, and automating database logic. At this point, Gotham's database was no longer cooperating voluntarily.

---

## 5. THE HERO ARCHITECTURE — CHALLENGE 50

*   The final boss query brings information from all four tables together simultaneously.
*   It filters unresolved incidents, checks compromised nodes using legacy encryption, and compares rogue danger scores against Gotham's citywide average.
*   In other words: All four tables finally had to cooperate. They did. Eventually.

---

## 6. TECHNOLOGY STACK

*   **Preprocessing Engine:** Python
*   **Data Cleaning Layer:** Pandas
*   **Database Engine:**   MySQL
*   **Database Interface:** MySQL Workbench
*   **Data Ingestion:**     MySQL Workbench Table Data Import Wizard
*   **SQL Frameworks:**    Joins, Aggregations, CTEs, Window Functions, Subqueries, Conditional Aggregation, Stored Procedures, Triggers, Schema Modification

---

## 7. REPOSITORY FILE TREE

```text
Project-Sentinel-SQL/
│
├── 📂 01_raw_data_sources/
│    ├── 📄 threat_incidents.csv
│    ├── 📄 rogue_gallery.csv
│    ├── 📄 tactics.csv
│    └── 📄 nodes.csv
│
├── 📄 gotham_threat_telemetry.sql   <-- Master 50-query compilation script
└── 📄 README.md                     <-- Technical homepage documentation
```

---

## 8. HOW TO RUN THE PROJECT

1.  **Prepare the CSV files:** Use Python/Pandas to clean and standardize the four datasets.
2.  **Open MySQL Workbench:** Create or select the MySQL database you want to use.
3.  **Import the datasets:** Use the MySQL Workbench Table Data Import Wizard to import the cleaned CSV files into their respective tables.
4.  **Load the SQL script:** Open `gotham_threat_telemetry.sql`.
5.  **Run the investigation:** Execute the queries from Case 1 through Case 50 and investigate Gotham one problem at a time.

---

## 9. CASE STATUS LOG

*   Evidence ............... **CLEANED 🐍**
*   Database ............... **LOADED 🗄️**
*   Queries ................ **50 / 50 COMPLETED 🏁**
*   Relational Joins ....... **SURVIVED**
*   Window Functions ....... **SURVIVED**
*   CTEs ................... **SURVIVED**
*   Stored Procedures ...... **SURVIVED**
*   Triggers ............... **SURVIVED**
*   Gotham ................. **STILL CHAOTIC**
*   Batman ................. **STILL AWAKE**
*   Analyst ................ **ABSOLUTELY NOT**

> *"Batman may not sleep, but this analyst has a bedtime."*

**Case closed. Gotham can survive one night without me.**
*   The laptop is closing.
*   The SQL is done.
*   The analyst is officially **OFF DUTY**. 100% Green Grids. 
---
### ⚠️ DISCLAIMER
*Gotham, its criminals, organizations, and events in this project are fictional/simulated and used strictly for educational and portfolio purposes. No actual Gotham residents were harmed or interrogated during this project.*