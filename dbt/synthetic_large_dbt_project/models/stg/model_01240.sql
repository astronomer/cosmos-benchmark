{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00476') }},
        {{ ref('model_00529') }}
)
select id, 'model_01240' as name from sources
