{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02051') }},
        {{ ref('model_01600') }}
)
select id, 'model_02684' as name from sources
