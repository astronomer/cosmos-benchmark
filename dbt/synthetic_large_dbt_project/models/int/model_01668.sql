{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01280') }},
        {{ ref('model_00761') }}
)
select id, 'model_01668' as name from sources
