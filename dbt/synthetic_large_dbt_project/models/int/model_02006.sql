{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01465') }},
        {{ ref('model_00924') }}
)
select id, 'model_02006' as name from sources
