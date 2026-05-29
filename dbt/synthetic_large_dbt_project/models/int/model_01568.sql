{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00873') }}
)
select id, 'model_01568' as name from sources
