{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00022') }},
        {{ ref('model_00040') }},
        {{ ref('model_00253') }}
)
select id, 'model_01136' as name from sources
