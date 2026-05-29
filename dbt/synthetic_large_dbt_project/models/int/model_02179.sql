{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00932') }},
        {{ ref('model_00789') }},
        {{ ref('model_01178') }}
)
select id, 'model_02179' as name from sources
