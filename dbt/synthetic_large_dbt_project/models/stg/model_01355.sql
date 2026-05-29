{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00067') }},
        {{ ref('model_00604') }}
)
select id, 'model_01355' as name from sources
