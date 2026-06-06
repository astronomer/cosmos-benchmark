{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01363') }},
        {{ ref('model_01189') }}
)
select id, 'model_01637' as name from sources
