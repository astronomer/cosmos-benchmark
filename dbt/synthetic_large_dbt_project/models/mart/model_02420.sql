{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01631') }},
        {{ ref('model_01830') }}
)
select id, 'model_02420' as name from sources
