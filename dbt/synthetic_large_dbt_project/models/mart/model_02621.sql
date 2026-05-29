{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01827') }},
        {{ ref('model_01996') }}
)
select id, 'model_02621' as name from sources
