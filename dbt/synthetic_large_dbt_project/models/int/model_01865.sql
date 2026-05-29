{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01314') }},
        {{ ref('model_00961') }},
        {{ ref('model_01202') }}
)
select id, 'model_01865' as name from sources
