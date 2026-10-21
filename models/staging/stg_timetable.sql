-- One row per student per class they are timetabled for.
select
    cast(admission_no as string)        as admission_no,
    trim(subject_name)                  as subject_name,
    upper(trim(teaching_group))         as teaching_group
from {{ ref('raw_timetable') }}
