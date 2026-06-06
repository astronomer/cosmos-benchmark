{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00817') }},
        {{ ref('model_01087') }}
)
select id, 'model_01800' as name from sources
