{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02238') }},
        {{ ref('model_02149') }}
)
select id, 'model_02926' as name from sources
