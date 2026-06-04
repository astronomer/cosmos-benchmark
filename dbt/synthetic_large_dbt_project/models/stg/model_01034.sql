{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00355') }},
        {{ ref('model_00403') }},
        {{ ref('model_00702') }}
)
select id, 'model_01034' as name from sources
