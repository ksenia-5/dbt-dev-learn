select
    id as order_id,
    user_id as customer_id,
    status as order_status,
    order_date,
    _etl_loaded_at as last_modified_at
from {{ source('jaffle_shop', 'orders') }}

{{ limit_data_in_dev(column_name='order_date', dev_days_of_data=1000) }}