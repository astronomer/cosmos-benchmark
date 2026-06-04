{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00985') }},
        {{ ref('model_01143') }},
        {{ ref('model_00835') }}
)
select id, 'model_01890' as name from sources
