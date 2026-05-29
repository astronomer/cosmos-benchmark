{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00638') }}
)
select id, 'model_00994' as name from sources
