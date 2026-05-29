{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00577') }},
        {{ ref('model_00063') }}
)
select id, 'model_00830' as name from sources
