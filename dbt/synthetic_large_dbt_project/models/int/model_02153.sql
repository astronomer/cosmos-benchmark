{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01478') }},
        {{ ref('model_01231') }},
        {{ ref('model_00853') }}
)
select id, 'model_02153' as name from sources
