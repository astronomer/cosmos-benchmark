{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00889') }},
        {{ ref('model_01482') }}
)
select id, 'model_01718' as name from sources
