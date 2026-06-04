{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01407') }},
        {{ ref('model_01297') }}
)
select id, 'model_01931' as name from sources
