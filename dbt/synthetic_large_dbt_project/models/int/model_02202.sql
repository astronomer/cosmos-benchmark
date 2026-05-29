{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01135') }},
        {{ ref('model_01048') }}
)
select id, 'model_02202' as name from sources
