{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01160') }},
        {{ ref('model_01168') }}
)
select id, 'model_01926' as name from sources
