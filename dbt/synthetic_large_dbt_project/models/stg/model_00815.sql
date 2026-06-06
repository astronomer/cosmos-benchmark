{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00090') }},
        {{ ref('model_00725') }},
        {{ ref('model_00686') }}
)
select id, 'model_00815' as name from sources
