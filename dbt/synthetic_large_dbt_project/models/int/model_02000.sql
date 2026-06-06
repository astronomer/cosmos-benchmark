{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01070') }},
        {{ ref('model_01255') }},
        {{ ref('model_01377') }}
)
select id, 'model_02000' as name from sources
