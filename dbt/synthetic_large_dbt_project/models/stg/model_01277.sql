{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00676') }},
        {{ ref('model_00195') }}
)
select id, 'model_01277' as name from sources
