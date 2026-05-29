{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02117') }}
)
select id, 'model_02758' as name from sources
