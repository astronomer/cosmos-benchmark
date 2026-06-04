{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00826') }},
        {{ ref('model_01297') }}
)
select id, 'model_02094' as name from sources
