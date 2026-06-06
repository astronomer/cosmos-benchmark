{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00874') }},
        {{ ref('model_01446') }}
)
select id, 'model_01602' as name from sources
