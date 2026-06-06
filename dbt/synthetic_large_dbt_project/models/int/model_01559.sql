{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00970') }},
        {{ ref('model_00937') }}
)
select id, 'model_01559' as name from sources
