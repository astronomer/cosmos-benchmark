{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01850') }},
        {{ ref('model_02153') }}
)
select id, 'model_02365' as name from sources
