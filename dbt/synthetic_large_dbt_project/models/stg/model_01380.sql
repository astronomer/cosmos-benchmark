{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00044') }},
        {{ ref('model_00067') }}
)
select id, 'model_01380' as name from sources
