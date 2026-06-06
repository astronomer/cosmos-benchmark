{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01945') }},
        {{ ref('model_02072') }},
        {{ ref('model_02219') }}
)
select id, 'model_02664' as name from sources
