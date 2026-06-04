{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00664') }},
        {{ ref('model_00170') }}
)
select id, 'model_00898' as name from sources
