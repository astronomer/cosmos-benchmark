{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00447') }},
        {{ ref('model_00404') }},
        {{ ref('model_00255') }}
)
select id, 'model_01066' as name from sources
