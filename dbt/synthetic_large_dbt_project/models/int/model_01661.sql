{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01300') }},
        {{ ref('model_01056') }},
        {{ ref('model_01083') }}
)
select id, 'model_01661' as name from sources
