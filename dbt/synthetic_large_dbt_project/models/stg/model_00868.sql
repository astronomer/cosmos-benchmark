{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00430') }},
        {{ ref('model_00339') }}
)
select id, 'model_00868' as name from sources
