{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00599') }},
        {{ ref('model_00494') }}
)
select id, 'model_00920' as name from sources
