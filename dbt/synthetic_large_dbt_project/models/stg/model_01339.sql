{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00709') }},
        {{ ref('model_00682') }},
        {{ ref('model_00157') }}
)
select id, 'model_01339' as name from sources
