{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02172') }},
        {{ ref('model_01632') }}
)
select id, 'model_02305' as name from sources
