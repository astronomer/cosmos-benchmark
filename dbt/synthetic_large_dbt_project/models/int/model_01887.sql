{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01080') }}
)
select id, 'model_01887' as name from sources
