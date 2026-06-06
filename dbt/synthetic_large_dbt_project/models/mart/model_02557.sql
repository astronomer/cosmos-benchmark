{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01711') }},
        {{ ref('model_01895') }},
        {{ ref('model_02081') }}
)
select id, 'model_02557' as name from sources
