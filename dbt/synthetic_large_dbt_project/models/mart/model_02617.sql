{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01893') }}
)
select id, 'model_02617' as name from sources
