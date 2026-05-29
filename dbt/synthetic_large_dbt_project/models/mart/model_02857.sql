{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02212') }}
)
select id, 'model_02857' as name from sources
