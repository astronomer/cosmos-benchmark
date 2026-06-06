{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00836') }},
        {{ ref('model_00811') }}
)
select id, 'model_02117' as name from sources
