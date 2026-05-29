{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00744') }},
        {{ ref('model_00641') }},
        {{ ref('model_00061') }}
)
select id, 'model_01426' as name from sources
