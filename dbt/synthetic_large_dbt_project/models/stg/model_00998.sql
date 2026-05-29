{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00120') }},
        {{ ref('model_00095') }},
        {{ ref('model_00493') }}
)
select id, 'model_00998' as name from sources
