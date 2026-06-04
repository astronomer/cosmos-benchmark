{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01110') }},
        {{ ref('model_01370') }},
        {{ ref('model_01301') }}
)
select id, 'model_01791' as name from sources
