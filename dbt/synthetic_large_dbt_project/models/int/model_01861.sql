{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01397') }},
        {{ ref('model_01369') }}
)
select id, 'model_01861' as name from sources
