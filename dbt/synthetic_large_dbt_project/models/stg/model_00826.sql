{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00640') }},
        {{ ref('model_00614') }},
        {{ ref('model_00491') }}
)
select id, 'model_00826' as name from sources
