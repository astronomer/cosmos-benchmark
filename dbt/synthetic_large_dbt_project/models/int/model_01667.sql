{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00988') }}
)
select id, 'model_01667' as name from sources
