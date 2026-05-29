{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00107') }},
        {{ ref('model_00405') }},
        {{ ref('model_00448') }}
)
select id, 'model_01393' as name from sources
