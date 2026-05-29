{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02036') }},
        {{ ref('model_02082') }},
        {{ ref('model_01969') }}
)
select id, 'model_02298' as name from sources
