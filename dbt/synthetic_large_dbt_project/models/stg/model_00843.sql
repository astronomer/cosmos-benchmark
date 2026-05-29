{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00411') }},
        {{ ref('model_00039') }},
        {{ ref('model_00405') }}
)
select id, 'model_00843' as name from sources
