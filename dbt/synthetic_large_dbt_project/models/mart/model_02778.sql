{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01669') }},
        {{ ref('model_01511') }},
        {{ ref('model_01603') }}
)
select id, 'model_02778' as name from sources
