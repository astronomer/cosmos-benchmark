{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00795') }},
        {{ ref('model_01032') }}
)
select id, 'model_02249' as name from sources
