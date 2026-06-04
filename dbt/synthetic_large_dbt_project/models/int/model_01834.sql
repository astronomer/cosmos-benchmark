{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00758') }},
        {{ ref('model_01194') }},
        {{ ref('model_01241') }}
)
select id, 'model_01834' as name from sources
