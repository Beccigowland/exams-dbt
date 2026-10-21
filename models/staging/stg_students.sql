-- One row per student. Cleans the raw MIS export.
select
    cast(admission_no as string)        as admission_no,
    cast(candidate_no as string)        as candidate_no,
    trim(first_name)                    as first_name,
    trim(last_name)                     as last_name,
    cast(year_group as int64)           as year_group,
    upper(trim(tutor_group))            as tutor_group,
    trim(access_arrangement)            as access_arrangement
from {{ ref('raw_students') }}
