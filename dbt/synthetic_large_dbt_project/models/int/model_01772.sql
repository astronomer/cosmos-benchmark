{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00759') }},
        {{ ref('model_01120') }},
        {{ ref('model_01493') }}
)
select id, 'model_01772' as name from sources
