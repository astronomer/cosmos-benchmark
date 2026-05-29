{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00214') }},
        {{ ref('model_00355') }}
)
select id, 'model_01421' as name from sources
