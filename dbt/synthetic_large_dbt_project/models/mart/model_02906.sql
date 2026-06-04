{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02096') }},
        {{ ref('model_01734') }},
        {{ ref('model_02089') }}
)
select id, 'model_02906' as name from sources
