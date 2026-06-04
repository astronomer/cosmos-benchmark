{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00924') }},
        {{ ref('model_01315') }}
)
select id, 'model_01597' as name from sources
