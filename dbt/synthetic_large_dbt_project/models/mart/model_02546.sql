{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01743') }},
        {{ ref('model_02199') }},
        {{ ref('model_02002') }}
)
select id, 'model_02546' as name from sources
