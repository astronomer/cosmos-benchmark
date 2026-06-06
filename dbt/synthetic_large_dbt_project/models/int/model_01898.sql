{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01176') }},
        {{ ref('model_00903') }},
        {{ ref('model_00936') }}
)
select id, 'model_01898' as name from sources
