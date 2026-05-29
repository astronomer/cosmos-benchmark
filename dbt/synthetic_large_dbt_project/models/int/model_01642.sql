{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01461') }},
        {{ ref('model_01244') }},
        {{ ref('model_01482') }}
)
select id, 'model_01642' as name from sources
