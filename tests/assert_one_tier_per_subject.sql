{{ config(severity='warn') }}

-- Fails if any student is entered for both Foundation and Higher in the same subject.
select
    admission_no,
    subject_name,
    count(distinct tier) as tiers_entered
from {{ ref('int_entries_enriched') }}
where is_entered
  and tier is not null
group by admission_no, subject_name
having count(distinct tier) > 1
