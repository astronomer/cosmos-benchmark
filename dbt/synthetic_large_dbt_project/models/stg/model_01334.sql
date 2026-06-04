{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00421') }},
        {{ ref('model_00592') }}
)
select id, 'model_01334' as name from sources
