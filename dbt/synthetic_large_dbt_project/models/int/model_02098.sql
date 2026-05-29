{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00813') }},
        {{ ref('model_00991') }},
        {{ ref('model_01255') }}
)
select id, 'model_02098' as name from sources
