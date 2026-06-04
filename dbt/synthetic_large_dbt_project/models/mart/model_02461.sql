{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01950') }},
        {{ ref('model_01971') }},
        {{ ref('model_02087') }}
)
select id, 'model_02461' as name from sources
