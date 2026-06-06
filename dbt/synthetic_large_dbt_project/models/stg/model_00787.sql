{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00266') }},
        {{ ref('model_00178') }}
)
select id, 'model_00787' as name from sources
