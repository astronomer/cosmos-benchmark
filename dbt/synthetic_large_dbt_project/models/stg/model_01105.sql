{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00380') }},
        {{ ref('model_00422') }}
)
select id, 'model_01105' as name from sources
