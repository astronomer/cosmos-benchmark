{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00896') }},
        {{ ref('model_01282') }},
        {{ ref('model_01335') }}
)
select id, 'model_01749' as name from sources
