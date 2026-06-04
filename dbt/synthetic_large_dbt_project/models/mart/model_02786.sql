{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02082') }},
        {{ ref('model_01698') }}
)
select id, 'model_02786' as name from sources
