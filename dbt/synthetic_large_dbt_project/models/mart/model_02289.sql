{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01843') }},
        {{ ref('model_02047') }},
        {{ ref('model_01873') }}
)
select id, 'model_02289' as name from sources
