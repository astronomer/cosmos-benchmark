{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01865') }},
        {{ ref('model_01598') }},
        {{ ref('model_01889') }}
)
select id, 'model_02896' as name from sources
