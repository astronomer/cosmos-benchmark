{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00588') }},
        {{ ref('model_00004') }}
)
select id, 'model_01020' as name from sources
