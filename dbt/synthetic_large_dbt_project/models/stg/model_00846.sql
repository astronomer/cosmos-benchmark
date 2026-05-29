{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00275') }},
        {{ ref('model_00746') }}
)
select id, 'model_00846' as name from sources
