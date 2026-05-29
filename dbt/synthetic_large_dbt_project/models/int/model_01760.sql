{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01183') }},
        {{ ref('model_01077') }}
)
select id, 'model_01760' as name from sources
