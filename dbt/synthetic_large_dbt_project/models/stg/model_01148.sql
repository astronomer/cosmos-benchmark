{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00631') }},
        {{ ref('model_00273') }},
        {{ ref('model_00620') }}
)
select id, 'model_01148' as name from sources
