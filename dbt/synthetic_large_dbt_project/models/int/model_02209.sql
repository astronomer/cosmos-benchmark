{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00904') }},
        {{ ref('model_00787') }}
)
select id, 'model_02209' as name from sources
