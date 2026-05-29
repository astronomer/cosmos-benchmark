{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00369') }},
        {{ ref('model_00440') }}
)
select id, 'model_01471' as name from sources
