{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00106') }},
        {{ ref('model_00210') }}
)
select id, 'model_00777' as name from sources
