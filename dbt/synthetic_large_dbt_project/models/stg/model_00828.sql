{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00271') }},
        {{ ref('model_00093') }},
        {{ ref('model_00657') }}
)
select id, 'model_00828' as name from sources
