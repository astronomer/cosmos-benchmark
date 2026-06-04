{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01382') }}
)
select id, 'model_01835' as name from sources
