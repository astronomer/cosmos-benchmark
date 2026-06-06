{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00339') }},
        {{ ref('model_00369') }},
        {{ ref('model_00300') }}
)
select id, 'model_00943' as name from sources
