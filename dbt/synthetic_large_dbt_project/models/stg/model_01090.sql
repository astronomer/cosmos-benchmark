{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00554') }},
        {{ ref('model_00375') }}
)
select id, 'model_01090' as name from sources
