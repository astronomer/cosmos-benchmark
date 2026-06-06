{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00203') }},
        {{ ref('model_00590') }},
        {{ ref('model_00589') }}
)
select id, 'model_01046' as name from sources
