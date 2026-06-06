{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00636') }},
        {{ ref('model_00274') }}
)
select id, 'model_00896' as name from sources
