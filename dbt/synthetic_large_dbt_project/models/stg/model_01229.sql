{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00240') }}
)
select id, 'model_01229' as name from sources
