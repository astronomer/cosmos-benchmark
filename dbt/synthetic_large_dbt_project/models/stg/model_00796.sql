{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00204') }},
        {{ ref('model_00658') }}
)
select id, 'model_00796' as name from sources
