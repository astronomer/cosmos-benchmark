{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01388') }},
        {{ ref('model_00968') }}
)
select id, 'model_01627' as name from sources
