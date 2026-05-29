{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01708') }},
        {{ ref('model_02246') }}
)
select id, 'model_02840' as name from sources
