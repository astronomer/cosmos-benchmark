{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01283') }},
        {{ ref('model_01489') }}
)
select id, 'model_01945' as name from sources
