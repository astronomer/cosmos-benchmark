{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01429') }},
        {{ ref('model_01379') }}
)
select id, 'model_01640' as name from sources
