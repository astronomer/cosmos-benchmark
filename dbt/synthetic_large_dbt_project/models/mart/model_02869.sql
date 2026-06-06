{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01606') }},
        {{ ref('model_02145') }},
        {{ ref('model_01517') }}
)
select id, 'model_02869' as name from sources
