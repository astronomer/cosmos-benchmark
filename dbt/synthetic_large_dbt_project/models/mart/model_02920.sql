{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02217') }},
        {{ ref('model_02046') }},
        {{ ref('model_01615') }}
)
select id, 'model_02920' as name from sources
