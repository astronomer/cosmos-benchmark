{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00185') }},
        {{ ref('model_00625') }}
)
select id, 'model_00900' as name from sources
