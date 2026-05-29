{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00111') }},
        {{ ref('model_00701') }},
        {{ ref('model_00610') }}
)
select id, 'model_01222' as name from sources
