{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01062') }},
        {{ ref('model_01454') }},
        {{ ref('model_00994') }}
)
select id, 'model_02027' as name from sources
