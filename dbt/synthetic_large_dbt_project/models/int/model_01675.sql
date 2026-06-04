{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01150') }},
        {{ ref('model_01377') }}
)
select id, 'model_01675' as name from sources
