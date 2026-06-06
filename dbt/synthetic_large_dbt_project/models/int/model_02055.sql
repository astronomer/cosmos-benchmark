{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01222') }},
        {{ ref('model_00778') }}
)
select id, 'model_02055' as name from sources
