{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00129') }},
        {{ ref('model_00451') }},
        {{ ref('model_00266') }}
)
select id, 'model_01340' as name from sources
