{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01280') }}
)
select id, 'model_01621' as name from sources
