{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00957') }},
        {{ ref('model_01159') }},
        {{ ref('model_00942') }}
)
select id, 'model_02015' as name from sources
