{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00482') }},
        {{ ref('model_00422') }}
)
select id, 'model_01447' as name from sources
