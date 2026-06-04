{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00968') }},
        {{ ref('model_01226') }}
)
select id, 'model_01991' as name from sources
