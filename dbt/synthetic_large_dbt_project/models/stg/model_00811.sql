{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00365') }},
        {{ ref('model_00228') }},
        {{ ref('model_00681') }}
)
select id, 'model_00811' as name from sources
