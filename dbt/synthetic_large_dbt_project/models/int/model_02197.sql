{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01421') }},
        {{ ref('model_01160') }}
)
select id, 'model_02197' as name from sources
