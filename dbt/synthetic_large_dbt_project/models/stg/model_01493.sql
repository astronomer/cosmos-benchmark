{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00479') }},
        {{ ref('model_00447') }}
)
select id, 'model_01493' as name from sources
