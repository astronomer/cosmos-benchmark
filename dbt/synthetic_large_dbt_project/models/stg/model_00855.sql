{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00020') }},
        {{ ref('model_00698') }},
        {{ ref('model_00009') }}
)
select id, 'model_00855' as name from sources
