{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01060') }},
        {{ ref('model_00990') }}
)
select id, 'model_01520' as name from sources
