{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00983') }},
        {{ ref('model_01285') }},
        {{ ref('model_01496') }}
)
select id, 'model_01599' as name from sources
