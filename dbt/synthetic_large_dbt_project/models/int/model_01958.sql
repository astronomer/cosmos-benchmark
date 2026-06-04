{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01155') }},
        {{ ref('model_00757') }},
        {{ ref('model_01133') }}
)
select id, 'model_01958' as name from sources
