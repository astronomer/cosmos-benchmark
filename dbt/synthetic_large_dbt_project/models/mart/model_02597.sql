{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01581') }},
        {{ ref('model_02190') }}
)
select id, 'model_02597' as name from sources
