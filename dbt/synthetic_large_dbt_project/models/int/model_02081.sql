{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01081') }},
        {{ ref('model_00987') }}
)
select id, 'model_02081' as name from sources
