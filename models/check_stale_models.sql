{% set database = target.database %}
{% set schema = target.schema %}
{% set days = 7 %}

select 
    table_type,
    table_schema,
    table_name,
    last_altered,
    case when table_type = 'VIEW' then table_type else 'TABLE' end as drop_type,
    'DROP ' || drop_type || ' {{ database | upper }}.'|| table_schema || '.' || table_name || ';' as st
from {{ database }}.information_schema.tables
where table_schema = upper('{{ schema }}') and last_altered <= current_date - {{ days }}
order by last_altered desc