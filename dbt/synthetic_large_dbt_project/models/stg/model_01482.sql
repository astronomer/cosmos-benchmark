{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00491') }},
        {{ ref('model_00464') }},
        {{ ref('model_00643') }}
)
select id, 'model_01482' as name from sources
