{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00664') }},
        {{ ref('model_00441') }},
        {{ ref('model_00534') }}
)
select id, 'model_00999' as name from sources
