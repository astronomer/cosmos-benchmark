{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01170') }}
)
select id, 'model_01697' as name from sources
