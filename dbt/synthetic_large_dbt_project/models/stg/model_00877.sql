{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00329') }}
)
select id, 'model_00877' as name from sources
