{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00062') }},
        {{ ref('model_00644') }}
)
select id, 'model_01245' as name from sources
