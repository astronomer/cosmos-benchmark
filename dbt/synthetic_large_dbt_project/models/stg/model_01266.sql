{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00263') }},
        {{ ref('model_00165') }}
)
select id, 'model_01266' as name from sources
