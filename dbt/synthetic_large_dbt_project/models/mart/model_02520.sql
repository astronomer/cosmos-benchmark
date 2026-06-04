{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01879') }},
        {{ ref('model_02197') }},
        {{ ref('model_02215') }}
)
select id, 'model_02520' as name from sources
