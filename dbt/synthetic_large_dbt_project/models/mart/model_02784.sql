{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01773') }},
        {{ ref('model_01647') }},
        {{ ref('model_01645') }}
)
select id, 'model_02784' as name from sources
