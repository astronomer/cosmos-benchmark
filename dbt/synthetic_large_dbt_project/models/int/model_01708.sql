{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01004') }},
        {{ ref('model_01453') }},
        {{ ref('model_01462') }}
)
select id, 'model_01708' as name from sources
