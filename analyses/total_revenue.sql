with 
stg_payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

aggregated as (
select 
    sum(case when payment_status='success' then amount else 0 end) as total_successful_payments
from stg_payments
)

select * from aggregated