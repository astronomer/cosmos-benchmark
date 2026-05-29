{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00346') }},
        {{ ref('model_00553') }},
        {{ ref('model_00454') }}
)
select id, 'model_01207' as name from sources
