{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00524') }},
        {{ ref('model_00040') }},
        {{ ref('model_00586') }}
)
select id, 'model_00990' as name from sources
