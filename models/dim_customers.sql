{{
    config(
        materialized='table'
        )
}}

with 

customers as (
    select
        id as customer_id,
        first_name,
        last_name
    from raw.jaffle_shop.customers
),

orders as (
    select
        id as order_id,
        user_id as customer_id,
        status as order_status,
        order_date,
        _etl_loaded_at as last_modified_at
    from raw.jaffle_shop.orders
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        count(order_id) as number_of_orders 
    from orders
    group by 1
),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.last_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers 
    left join customer_orders using(customer_id)
)

select * from final