{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01244') }},
        {{ ref('model_01048') }},
        {{ ref('model_00898') }}
)
select id, 'model_01771' as name from sources
