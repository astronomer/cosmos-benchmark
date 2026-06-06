{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01395') }},
        {{ ref('model_01275') }}
)
select id, 'model_02173' as name from sources
