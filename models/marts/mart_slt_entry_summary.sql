-- One row per student: the view SLT sees (your old "Entry info" tab).
with entries as (
    select * from {{ ref('int_entries_enriched') }}
),

per_student as (
    select
        admission_no,
        sum(case when is_entered then 1 else 0 end)                      as subjects_entered,
        sum(case when entry_status = 'W' then 1 else 0 end)              as subjects_withdrawn,
        max(case when subject_name = 'Mathematics' and is_entered then tier end)      as maths_tier,
        max(case when subject_name = 'Combined Science' and is_entered then tier end) as science_tier,
        max(case when subject_name = 'Spanish' and is_entered then tier end)          as spanish_tier
    from entries
    group by admission_no
)

select
    st.admission_no,
    st.candidate_no,
    st.first_name,
    st.last_name,
    st.year_group,
    st.tutor_group,
    st.access_arrangement,
    st.access_arrangement = '25% extra time'    as has_extra_time,
    coalesce(p.subjects_entered, 0)             as subjects_entered,
    coalesce(p.subjects_withdrawn, 0)           as subjects_withdrawn,
    p.maths_tier,
    p.science_tier,
    p.spanish_tier
from {{ ref('stg_students') }} as st
left join per_student as p
    on st.admission_no = p.admission_no
