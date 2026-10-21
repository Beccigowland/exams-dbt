-- One row per entry. Fixes stray spaces and lower-case entry codes.
select
    cast(admission_no as string)        as admission_no,
    upper(trim(entry_code))             as entry_code,
    upper(trim(entry_status))           as entry_status
from {{ ref('raw_entries') }}
