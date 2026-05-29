{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02234') }},
        {{ ref('model_01633') }}
)
select id, 'model_02949' as name from sources
