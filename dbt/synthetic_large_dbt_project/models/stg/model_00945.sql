{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00249') }},
        {{ ref('model_00040') }},
        {{ ref('model_00698') }}
)
select id, 'model_00945' as name from sources
