{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01470') }},
        {{ ref('model_00896') }},
        {{ ref('model_01136') }}
)
select id, 'model_01895' as name from sources
