{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01231') }},
        {{ ref('model_01171') }}
)
select id, 'model_01899' as name from sources
