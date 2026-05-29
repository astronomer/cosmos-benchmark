{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00619') }},
        {{ ref('model_00660') }}
)
select id, 'model_01051' as name from sources
