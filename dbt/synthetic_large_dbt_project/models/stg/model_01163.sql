{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00167') }},
        {{ ref('model_00735') }},
        {{ ref('model_00126') }}
)
select id, 'model_01163' as name from sources
