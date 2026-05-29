{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01104') }}
)
select id, 'model_02099' as name from sources
