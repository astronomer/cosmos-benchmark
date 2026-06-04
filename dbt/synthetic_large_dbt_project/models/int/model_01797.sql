{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01463') }},
        {{ ref('model_01411') }},
        {{ ref('model_00947') }}
)
select id, 'model_01797' as name from sources
