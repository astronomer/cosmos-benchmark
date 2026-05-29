{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00940') }},
        {{ ref('model_00998') }}
)
select id, 'model_01618' as name from sources
