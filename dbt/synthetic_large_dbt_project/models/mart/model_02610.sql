{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02145') }},
        {{ ref('model_01818') }}
)
select id, 'model_02610' as name from sources
