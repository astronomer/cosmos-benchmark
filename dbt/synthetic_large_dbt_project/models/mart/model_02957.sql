{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02204') }},
        {{ ref('model_01848') }},
        {{ ref('model_01538') }}
)
select id, 'model_02957' as name from sources
