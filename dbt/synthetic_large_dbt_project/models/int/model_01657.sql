{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01098') }},
        {{ ref('model_00837') }}
)
select id, 'model_01657' as name from sources
