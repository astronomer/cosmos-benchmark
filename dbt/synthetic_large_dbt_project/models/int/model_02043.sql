{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00903') }},
        {{ ref('model_01285') }},
        {{ ref('model_01046') }}
)
select id, 'model_02043' as name from sources
