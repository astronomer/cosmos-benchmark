{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02025') }},
        {{ ref('model_01574') }}
)
select id, 'model_02709' as name from sources
