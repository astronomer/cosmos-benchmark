{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00409') }},
        {{ ref('model_00467') }}
)
select id, 'model_00897' as name from sources
