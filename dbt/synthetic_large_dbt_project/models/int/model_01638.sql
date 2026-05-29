{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01051') }},
        {{ ref('model_00902') }},
        {{ ref('model_01085') }}
)
select id, 'model_01638' as name from sources
