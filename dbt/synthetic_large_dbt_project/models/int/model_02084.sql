{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00860') }},
        {{ ref('model_01465') }}
)
select id, 'model_02084' as name from sources
