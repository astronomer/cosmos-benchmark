{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00755') }},
        {{ ref('model_01454') }},
        {{ ref('model_00803') }}
)
select id, 'model_02004' as name from sources
