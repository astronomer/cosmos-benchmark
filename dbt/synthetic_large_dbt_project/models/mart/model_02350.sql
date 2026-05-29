{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01733') }},
        {{ ref('model_01707') }},
        {{ ref('model_01872') }}
)
select id, 'model_02350' as name from sources
