{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00308') }},
        {{ ref('model_00356') }},
        {{ ref('model_00428') }}
)
select id, 'model_01296' as name from sources
