{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00144') }},
        {{ ref('model_00339') }}
)
select id, 'model_00814' as name from sources
