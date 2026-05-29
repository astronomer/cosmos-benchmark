{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00060') }},
        {{ ref('model_00022') }}
)
select id, 'model_00807' as name from sources
