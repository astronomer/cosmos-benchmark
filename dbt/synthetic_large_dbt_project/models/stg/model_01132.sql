{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00632') }},
        {{ ref('model_00277') }},
        {{ ref('model_00054') }}
)
select id, 'model_01132' as name from sources
