{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01788') }},
        {{ ref('model_01540') }}
)
select id, 'model_02292' as name from sources
