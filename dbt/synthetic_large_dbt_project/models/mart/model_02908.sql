{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01521') }},
        {{ ref('model_02183') }},
        {{ ref('model_01781') }}
)
select id, 'model_02908' as name from sources
