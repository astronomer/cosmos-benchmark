{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01136') }}
)
select id, 'model_01610' as name from sources
