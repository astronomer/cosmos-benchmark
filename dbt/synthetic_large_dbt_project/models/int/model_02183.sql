{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01428') }}
)
select id, 'model_02183' as name from sources
