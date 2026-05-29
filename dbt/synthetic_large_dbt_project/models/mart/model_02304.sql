{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01685') }},
        {{ ref('model_02194') }}
)
select id, 'model_02304' as name from sources
