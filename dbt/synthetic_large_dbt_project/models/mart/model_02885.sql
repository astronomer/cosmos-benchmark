{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01514') }},
        {{ ref('model_01984') }}
)
select id, 'model_02885' as name from sources
