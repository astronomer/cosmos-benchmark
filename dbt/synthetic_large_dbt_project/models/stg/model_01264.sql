{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00663') }},
        {{ ref('model_00579') }},
        {{ ref('model_00189') }}
)
select id, 'model_01264' as name from sources
