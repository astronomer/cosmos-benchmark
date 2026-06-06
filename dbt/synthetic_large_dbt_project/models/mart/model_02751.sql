{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01990') }},
        {{ ref('model_01661') }}
)
select id, 'model_02751' as name from sources
