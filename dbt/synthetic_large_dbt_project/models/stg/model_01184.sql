{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00120') }},
        {{ ref('model_00212') }},
        {{ ref('model_00630') }}
)
select id, 'model_01184' as name from sources
