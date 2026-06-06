{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00320') }},
        {{ ref('model_00565') }},
        {{ ref('model_00055') }}
)
select id, 'model_00934' as name from sources
