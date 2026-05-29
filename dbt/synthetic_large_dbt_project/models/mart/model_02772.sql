{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01750') }},
        {{ ref('model_01645') }}
)
select id, 'model_02772' as name from sources
