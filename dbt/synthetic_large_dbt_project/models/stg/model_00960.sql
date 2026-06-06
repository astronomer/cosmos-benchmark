{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }},
        {{ ref('model_00403') }},
        {{ ref('model_00550') }}
)
select id, 'model_00960' as name from sources
