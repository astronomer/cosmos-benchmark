{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01639') }},
        {{ ref('model_01682') }},
        {{ ref('model_01545') }}
)
select id, 'model_02924' as name from sources
