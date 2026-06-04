{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01145') }},
        {{ ref('model_01464') }}
)
select id, 'model_02070' as name from sources
