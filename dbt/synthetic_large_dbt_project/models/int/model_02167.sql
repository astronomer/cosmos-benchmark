{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00922') }},
        {{ ref('model_00778') }},
        {{ ref('model_01362') }}
)
select id, 'model_02167' as name from sources
