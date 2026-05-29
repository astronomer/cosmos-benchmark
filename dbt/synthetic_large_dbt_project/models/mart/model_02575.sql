{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02001') }}
)
select id, 'model_02575' as name from sources
