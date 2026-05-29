{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00527') }},
        {{ ref('model_00118') }}
)
select id, 'model_01302' as name from sources
