{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01764') }},
        {{ ref('model_01702') }},
        {{ ref('model_02027') }}
)
select id, 'model_02291' as name from sources
