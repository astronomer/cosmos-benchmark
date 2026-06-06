{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01262') }},
        {{ ref('model_01110') }}
)
select id, 'model_02089' as name from sources
