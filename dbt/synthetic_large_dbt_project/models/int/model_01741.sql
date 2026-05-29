{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01072') }},
        {{ ref('model_00995') }}
)
select id, 'model_01741' as name from sources
