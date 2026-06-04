{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02202') }}
)
select id, 'model_02748' as name from sources
