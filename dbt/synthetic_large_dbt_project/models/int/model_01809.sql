{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01229') }},
        {{ ref('model_01264') }}
)
select id, 'model_01809' as name from sources
