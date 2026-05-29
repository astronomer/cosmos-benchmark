{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00828') }},
        {{ ref('model_01006') }},
        {{ ref('model_01306') }}
)
select id, 'model_02110' as name from sources
