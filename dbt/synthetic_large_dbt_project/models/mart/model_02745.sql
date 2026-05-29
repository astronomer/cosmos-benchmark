{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01710') }},
        {{ ref('model_01881') }},
        {{ ref('model_01647') }}
)
select id, 'model_02745' as name from sources
