{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00048') }},
        {{ ref('model_00407') }},
        {{ ref('model_00101') }}
)
select id, 'model_01043' as name from sources
