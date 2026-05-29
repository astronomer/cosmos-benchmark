{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00959') }},
        {{ ref('model_01278') }},
        {{ ref('model_00897') }}
)
select id, 'model_02061' as name from sources
