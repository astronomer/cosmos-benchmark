{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02241') }},
        {{ ref('model_02153') }},
        {{ ref('model_01603') }}
)
select id, 'model_02299' as name from sources
