{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01430') }}
)
select id, 'model_01692' as name from sources
