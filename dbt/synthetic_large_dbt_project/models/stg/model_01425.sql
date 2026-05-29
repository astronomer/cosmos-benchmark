{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00274') }},
        {{ ref('model_00653') }}
)
select id, 'model_01425' as name from sources
