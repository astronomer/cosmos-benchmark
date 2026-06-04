{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01462') }},
        {{ ref('model_00878') }}
)
select id, 'model_02104' as name from sources
