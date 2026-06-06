{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00343') }},
        {{ ref('model_00276') }}
)
select id, 'model_01257' as name from sources
