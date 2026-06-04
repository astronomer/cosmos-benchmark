{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01930') }},
        {{ ref('model_01761') }},
        {{ ref('model_02163') }}
)
select id, 'model_02874' as name from sources
