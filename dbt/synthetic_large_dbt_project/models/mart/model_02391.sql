{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01941') }},
        {{ ref('model_01783') }},
        {{ ref('model_01976') }}
)
select id, 'model_02391' as name from sources
