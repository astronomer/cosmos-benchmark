{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00171') }},
        {{ ref('model_00036') }}
)
select id, 'model_01244' as name from sources
