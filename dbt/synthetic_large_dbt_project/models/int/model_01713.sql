{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01400') }},
        {{ ref('model_00956') }}
)
select id, 'model_01713' as name from sources
