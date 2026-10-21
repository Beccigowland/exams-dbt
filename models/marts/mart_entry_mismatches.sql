-- Class lists checked against entries. Any row here needs action before the deadline.
with classes as (
    select distinct admission_no, subject_name
    from {{ ref('stg_timetable') }}
),

entries as (
    select
        admission_no,
        subject_name,
        max(case when is_entered then 1 else 0 end)        as is_entered,
        max(case when entry_status = 'W' then 1 else 0 end) as is_withdrawn
    from {{ ref('int_entries_enriched') }}
    group by admission_no, subject_name
),

compared as (
    select
        coalesce(c.admission_no, e.admission_no)  as admission_no,
        coalesce(c.subject_name, e.subject_name)  as subject_name,
        c.admission_no is not null                as in_class,
        coalesce(e.is_entered, 0) = 1             as is_entered,
        coalesce(e.is_withdrawn, 0) = 1           as is_withdrawn
    from classes as c
    full outer join entries as e
        on c.admission_no = e.admission_no
       and c.subject_name = e.subject_name
)

select
    admission_no,
    subject_name,
    case
        when in_class and is_withdrawn and not is_entered then 'Withdrawn but still in class'
        when in_class and not is_entered                  then 'In class, not entered'
        when is_entered and not in_class                  then 'Entered, not in class'
    end as issue
from compared
where (in_class and not is_entered)
   or (is_entered and not in_class)
