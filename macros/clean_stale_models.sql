{#

develop a macro that

1. queries the information schema of a database
2. finds objects that are > 1 week old (no longer maintained)
3. generates automated drop statements
4. has the ability to execute those drop statements

To run use `dbt run-operation clean_stale_models --args '{'dry_run' : 'False'}'`

#}

{% macro clean_stale_models(database=target.database, schema=target.schema, days=7, dry_run=True) %}

    {% set get_drop_commands_query %}
        select 
            case when table_type = 'VIEW' then table_type else 'TABLE' end as drop_type,
            'DROP ' || drop_type || ' {{ database | upper }}.'|| table_schema || '.' || table_name || ';' as st
        from {{ database }}.information_schema.tables
        where table_schema = upper('{{ schema }}') 
        and last_altered <= current_date - {{ days }}
        order by last_altered desc
    {% endset %}

    {{ log('\nGenerating clean-up queries...\n', info=True) }}
    {% set drop_queries=run_query(get_drop_commands_query).columns[1].values() %}
    {% for query in drop_queries %}

    {% if dry_run %}
        {{ log(query, info=True)}}
    {% else %}
        {{ log('Dropping object  with command ' ~ query, info=True) }}
        {% do run_query(query) %} 

    {% endif %}
         
    {% endfor %}

{% endmacro %}