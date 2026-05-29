{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00585') }},
        {{ ref('model_00608') }},
        {{ ref('model_00549') }}
)
select id, 'model_01155' as name from sources
