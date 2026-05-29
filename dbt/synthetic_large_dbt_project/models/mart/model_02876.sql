{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02187') }}
)
select id, 'model_02876' as name from sources
