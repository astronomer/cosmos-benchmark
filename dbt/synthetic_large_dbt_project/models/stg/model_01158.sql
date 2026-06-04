{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00407') }},
        {{ ref('model_00311') }}
)
select id, 'model_01158' as name from sources
