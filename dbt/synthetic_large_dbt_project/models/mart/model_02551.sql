{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01971') }},
        {{ ref('model_01963') }}
)
select id, 'model_02551' as name from sources
