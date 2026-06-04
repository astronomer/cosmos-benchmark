{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01030') }},
        {{ ref('model_01120') }},
        {{ ref('model_01025') }}
)
select id, 'model_02126' as name from sources
