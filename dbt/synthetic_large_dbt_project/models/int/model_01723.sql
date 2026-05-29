{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00809') }},
        {{ ref('model_01416') }},
        {{ ref('model_01144') }}
)
select id, 'model_01723' as name from sources
