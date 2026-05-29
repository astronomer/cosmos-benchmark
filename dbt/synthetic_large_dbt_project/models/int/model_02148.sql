{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01369') }},
        {{ ref('model_00985') }}
)
select id, 'model_02148' as name from sources
