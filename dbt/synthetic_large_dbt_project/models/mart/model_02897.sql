{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01844') }}
)
select id, 'model_02897' as name from sources
