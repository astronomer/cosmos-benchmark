{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00472') }},
        {{ ref('model_00660') }},
        {{ ref('model_00562') }}
)
select id, 'model_00963' as name from sources
