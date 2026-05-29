{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00162') }},
        {{ ref('model_00067') }},
        {{ ref('model_00318') }}
)
select id, 'model_00848' as name from sources
