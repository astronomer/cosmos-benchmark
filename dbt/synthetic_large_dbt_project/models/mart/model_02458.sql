{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01891') }},
        {{ ref('model_01543') }},
        {{ ref('model_02116') }}
)
select id, 'model_02458' as name from sources
