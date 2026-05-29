{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00876') }},
        {{ ref('model_01030') }},
        {{ ref('model_01473') }}
)
select id, 'model_01764' as name from sources
