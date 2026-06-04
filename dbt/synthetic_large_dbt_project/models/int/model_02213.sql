{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00874') }},
        {{ ref('model_00920') }},
        {{ ref('model_00952') }}
)
select id, 'model_02213' as name from sources
