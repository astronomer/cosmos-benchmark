{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01347') }},
        {{ ref('model_00858') }},
        {{ ref('model_01489') }}
)
select id, 'model_01864' as name from sources
