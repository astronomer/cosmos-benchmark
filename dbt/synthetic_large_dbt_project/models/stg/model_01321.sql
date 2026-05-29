{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00555') }},
        {{ ref('model_00589') }},
        {{ ref('model_00212') }}
)
select id, 'model_01321' as name from sources
