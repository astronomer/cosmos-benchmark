{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01782') }},
        {{ ref('model_02083') }},
        {{ ref('model_01758') }}
)
select id, 'model_02489' as name from sources
