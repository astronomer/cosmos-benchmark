{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01703') }},
        {{ ref('model_01772') }}
)
select id, 'model_02730' as name from sources
