{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00935') }},
        {{ ref('model_01445') }},
        {{ ref('model_01185') }}
)
select id, 'model_01883' as name from sources
