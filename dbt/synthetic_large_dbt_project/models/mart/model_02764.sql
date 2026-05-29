{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01754') }},
        {{ ref('model_01665') }},
        {{ ref('model_02155') }}
)
select id, 'model_02764' as name from sources
