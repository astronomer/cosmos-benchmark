{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00527') }},
        {{ ref('model_00464') }},
        {{ ref('model_00687') }}
)
select id, 'model_01423' as name from sources
