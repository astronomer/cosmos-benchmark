{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02163') }},
        {{ ref('model_01655') }},
        {{ ref('model_01552') }}
)
select id, 'model_02804' as name from sources
