{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02169') }},
        {{ ref('model_02222') }}
)
select id, 'model_02812' as name from sources
