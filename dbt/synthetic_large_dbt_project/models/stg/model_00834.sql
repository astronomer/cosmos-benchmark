{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00693') }},
        {{ ref('model_00635') }},
        {{ ref('model_00150') }}
)
select id, 'model_00834' as name from sources
