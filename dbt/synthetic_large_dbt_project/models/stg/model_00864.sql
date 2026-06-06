{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00036') }},
        {{ ref('model_00597') }}
)
select id, 'model_00864' as name from sources
