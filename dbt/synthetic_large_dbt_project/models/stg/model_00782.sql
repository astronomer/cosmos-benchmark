{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00334') }},
        {{ ref('model_00325') }},
        {{ ref('model_00463') }}
)
select id, 'model_00782' as name from sources
