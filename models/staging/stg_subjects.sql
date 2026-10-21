-- Lookup: which subject and tier each entry code belongs to.
select
    upper(trim(entry_code))             as entry_code,
    trim(subject_name)                  as subject_name,
    trim(awarding_body)                 as awarding_body,
    nullif(trim(tier), '')              as tier
from {{ ref('raw_subjects') }}
