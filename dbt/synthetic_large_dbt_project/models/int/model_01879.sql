{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01421') }},
        {{ ref('model_01043') }}
)
select id, 'model_01879' as name from sources
