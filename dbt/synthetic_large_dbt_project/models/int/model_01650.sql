{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00983') }},
        {{ ref('model_00850') }}
)
select id, 'model_01650' as name from sources
