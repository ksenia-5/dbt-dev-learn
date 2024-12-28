select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status as payment_status,
    round(amount / 100.0, 2) as amount,
    created as payment_created_at,
    _batched_at as last_modified_at
from {{ source('stripe', 'payment') }}