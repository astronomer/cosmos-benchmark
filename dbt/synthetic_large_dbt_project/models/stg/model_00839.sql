{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00115') }},
        {{ ref('model_00424') }}
)
select id, 'model_00839' as name from sources
