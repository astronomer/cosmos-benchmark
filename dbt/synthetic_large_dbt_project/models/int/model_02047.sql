{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01431') }},
        {{ ref('model_01324') }},
        {{ ref('model_00908') }}
)
select id, 'model_02047' as name from sources
