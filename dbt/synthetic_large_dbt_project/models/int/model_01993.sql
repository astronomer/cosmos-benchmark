{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01372') }},
        {{ ref('model_01437') }},
        {{ ref('model_00826') }}
)
select id, 'model_01993' as name from sources
