{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00250') }},
        {{ ref('model_00029') }},
        {{ ref('model_00122') }}
)
select id, 'model_01361' as name from sources
