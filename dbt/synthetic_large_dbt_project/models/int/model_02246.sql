{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01378') }},
        {{ ref('model_00767') }},
        {{ ref('model_01090') }}
)
select id, 'model_02246' as name from sources
