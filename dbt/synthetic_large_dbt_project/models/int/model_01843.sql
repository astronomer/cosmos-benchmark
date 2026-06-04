{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01002') }},
        {{ ref('model_01077') }}
)
select id, 'model_01843' as name from sources
