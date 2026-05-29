{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01405') }},
        {{ ref('model_00908') }},
        {{ ref('model_01058') }}
)
select id, 'model_02062' as name from sources
