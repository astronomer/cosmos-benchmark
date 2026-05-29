{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00289') }},
        {{ ref('model_00330') }},
        {{ ref('model_00419') }}
)
select id, 'model_01093' as name from sources
