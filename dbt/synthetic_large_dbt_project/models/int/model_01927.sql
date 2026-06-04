{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01071') }},
        {{ ref('model_01132') }},
        {{ ref('model_00835') }}
)
select id, 'model_01927' as name from sources
