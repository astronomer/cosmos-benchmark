{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01306') }},
        {{ ref('model_01017') }},
        {{ ref('model_00758') }}
)
select id, 'model_01653' as name from sources
