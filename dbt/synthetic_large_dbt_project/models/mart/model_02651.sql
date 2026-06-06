{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01835') }},
        {{ ref('model_01968') }},
        {{ ref('model_01900') }}
)
select id, 'model_02651' as name from sources
