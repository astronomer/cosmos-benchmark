{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01981') }},
        {{ ref('model_01547') }},
        {{ ref('model_02175') }}
)
select id, 'model_02377' as name from sources
