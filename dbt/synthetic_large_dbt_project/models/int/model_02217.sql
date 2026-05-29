{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01285') }},
        {{ ref('model_01451') }}
)
select id, 'model_02217' as name from sources
