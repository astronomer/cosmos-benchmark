{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01900') }}
)
select id, 'model_02445' as name from sources
