{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00337') }},
        {{ ref('model_00400') }},
        {{ ref('model_00588') }}
)
select id, 'model_01272' as name from sources
