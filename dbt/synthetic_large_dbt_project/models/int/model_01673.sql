{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01002') }},
        {{ ref('model_01288') }},
        {{ ref('model_01086') }}
)
select id, 'model_01673' as name from sources
