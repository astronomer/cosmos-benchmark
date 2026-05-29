{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01257') }},
        {{ ref('model_01196') }}
)
select id, 'model_01982' as name from sources
