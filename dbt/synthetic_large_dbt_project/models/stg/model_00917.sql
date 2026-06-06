{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00220') }},
        {{ ref('model_00468') }}
)
select id, 'model_00917' as name from sources
