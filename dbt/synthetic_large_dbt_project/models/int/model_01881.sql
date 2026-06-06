{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01115') }},
        {{ ref('model_00828') }}
)
select id, 'model_01881' as name from sources
