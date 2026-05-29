{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00568') }},
        {{ ref('model_00548') }}
)
select id, 'model_01191' as name from sources
