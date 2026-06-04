{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01071') }}
)
select id, 'model_01990' as name from sources
