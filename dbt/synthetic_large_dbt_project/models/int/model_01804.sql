{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01314') }},
        {{ ref('model_01027') }}
)
select id, 'model_01804' as name from sources
