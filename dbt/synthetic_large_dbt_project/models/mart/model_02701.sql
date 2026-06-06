{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01524') }}
)
select id, 'model_02701' as name from sources
