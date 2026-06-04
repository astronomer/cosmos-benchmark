{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01086') }},
        {{ ref('model_01055') }}
)
select id, 'model_01822' as name from sources
