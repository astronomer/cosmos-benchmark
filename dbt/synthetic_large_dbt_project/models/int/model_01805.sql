{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00935') }},
        {{ ref('model_01103') }}
)
select id, 'model_01805' as name from sources
