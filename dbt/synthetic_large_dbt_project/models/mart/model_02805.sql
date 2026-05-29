{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02195') }},
        {{ ref('model_02202') }}
)
select id, 'model_02805' as name from sources
