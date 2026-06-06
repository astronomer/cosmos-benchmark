{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00026') }},
        {{ ref('model_00291') }}
)
select id, 'model_01480' as name from sources
