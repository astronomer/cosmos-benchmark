{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01526') }},
        {{ ref('model_02006') }}
)
select id, 'model_02477' as name from sources
