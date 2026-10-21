-- Adds subject name and tier to every entry (your old "Tiers" tab).
select
    e.admission_no,
    e.entry_code,
    s.subject_name,
    s.awarding_body,
    s.tier,
    e.entry_status,
    e.entry_status = 'C'                as is_entered
from {{ ref('stg_entries') }} as e
left join {{ ref('stg_subjects') }} as s
    on e.entry_code = s.entry_code
