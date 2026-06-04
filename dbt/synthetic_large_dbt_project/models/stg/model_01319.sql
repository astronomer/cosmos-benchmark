{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00641') }},
        {{ ref('model_00475') }}
)
select id, 'model_01319' as name from sources
