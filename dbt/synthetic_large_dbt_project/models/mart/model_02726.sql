{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02163') }}
)
select id, 'model_02726' as name from sources
