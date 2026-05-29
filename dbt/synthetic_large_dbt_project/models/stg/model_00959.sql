{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00663') }},
        {{ ref('model_00382') }},
        {{ ref('model_00011') }}
)
select id, 'model_00959' as name from sources
