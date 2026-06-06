{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01170') }},
        {{ ref('model_01110') }}
)
select id, 'model_01950' as name from sources
