select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status as payment_status,
    {{ cents_to_dollars('amount') }} as amount,
    created as payment_created_at,
    _batched_at as last_modified_at
from {{ source('stripe', 'payment') }}