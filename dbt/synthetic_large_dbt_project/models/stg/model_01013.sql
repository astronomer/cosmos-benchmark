{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00628') }},
        {{ ref('model_00671') }}
)
select id, 'model_01013' as name from sources
