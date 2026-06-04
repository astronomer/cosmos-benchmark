{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02111') }}
)
select id, 'model_02968' as name from sources
