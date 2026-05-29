{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00833') }},
        {{ ref('model_00857') }},
        {{ ref('model_01185') }}
)
select id, 'model_02212' as name from sources
