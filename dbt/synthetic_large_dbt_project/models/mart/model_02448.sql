{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01782') }},
        {{ ref('model_01835') }},
        {{ ref('model_01511') }}
)
select id, 'model_02448' as name from sources
