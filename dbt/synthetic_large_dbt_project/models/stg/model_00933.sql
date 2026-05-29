{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00294') }},
        {{ ref('model_00709') }},
        {{ ref('model_00680') }}
)
select id, 'model_00933' as name from sources
