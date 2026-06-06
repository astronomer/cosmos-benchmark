{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00183') }},
        {{ ref('model_00571') }},
        {{ ref('model_00425') }}
)
select id, 'model_01102' as name from sources
