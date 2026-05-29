{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02077') }},
        {{ ref('model_01886') }}
)
select id, 'model_02263' as name from sources
