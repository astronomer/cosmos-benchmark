{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00927') }},
        {{ ref('model_01173') }},
        {{ ref('model_01319') }}
)
select id, 'model_01589' as name from sources
