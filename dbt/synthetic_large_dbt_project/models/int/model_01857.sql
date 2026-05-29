{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01463') }},
        {{ ref('model_00759') }},
        {{ ref('model_01275') }}
)
select id, 'model_01857' as name from sources
