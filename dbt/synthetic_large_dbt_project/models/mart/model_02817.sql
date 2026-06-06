{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02065') }},
        {{ ref('model_02246') }},
        {{ ref('model_02101') }}
)
select id, 'model_02817' as name from sources
