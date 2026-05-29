{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00697') }},
        {{ ref('model_00658') }},
        {{ ref('model_00067') }}
)
select id, 'model_00759' as name from sources
