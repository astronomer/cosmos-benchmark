{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00497') }},
        {{ ref('model_00020') }},
        {{ ref('model_00056') }}
)
select id, 'model_01433' as name from sources
