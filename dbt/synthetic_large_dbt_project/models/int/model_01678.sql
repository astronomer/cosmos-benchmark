{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00818') }},
        {{ ref('model_01464') }},
        {{ ref('model_01493') }}
)
select id, 'model_01678' as name from sources
