{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00842') }},
        {{ ref('model_01471') }}
)
select id, 'model_02191' as name from sources
