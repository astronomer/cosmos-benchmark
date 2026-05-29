{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01150') }},
        {{ ref('model_00823') }}
)
select id, 'model_01768' as name from sources
