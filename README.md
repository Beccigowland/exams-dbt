# Exam entries checker (dbt + BigQuery)

A dbt project that rebuilds an Excel workbook I used as an Examinations Manager to check
GCSE entries before awarding-body deadlines. It turns raw exports into a clean summary for
senior leaders and a list of entry problems to fix.

**All data is made up** (60 fictional students). No real pupil data is used.

## What it answers

- Is every student entered for the subjects they are timetabled for, and only those?
- Which tier (Foundation or Higher) is each student entered for in Maths, Science and Spanish?
- Who has a withdrawn entry but is still in the class?

## How it is built

| Layer | Models | What it does |
| --- | --- | --- |
| Seeds | `raw_students`, `raw_entries`, `raw_timetable`, `raw_subjects` | Raw exports, left messy on purpose (stray spaces, lower-case codes) |
| Staging | `stg_*` | One clean model per source: trims, fixes case, sets data types |
| Intermediate | `int_entries_enriched` | Joins each entry to the subject lookup to get subject and tier |
| Marts | `mart_slt_entry_summary`, `mart_entry_mismatches` | One row per student for SLT; one row per entry problem to fix |

## Tests

30 data tests: unique and not-null keys, relationships between tables, accepted values,
and a custom test that no student is entered for both tiers of one subject.

Two problems are planted in the data and caught as warnings:

- an entry for a student who does not exist (relationships test)
- a student entered for both Foundation and Higher Maths (custom test)

`mart_entry_mismatches` returns 10 rows: students in a class but not entered, entered
but not in the class, and withdrawn but still timetabled.

## Run it

```
dbt seed
dbt build
```

Built on dbt platform with Google BigQuery, October 2026.
