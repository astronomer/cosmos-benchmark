{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00302') }}
)
select id, 'model_01309' as name from sources
