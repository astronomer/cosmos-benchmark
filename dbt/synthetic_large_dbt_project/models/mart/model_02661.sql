{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02090') }}
)
select id, 'model_02661' as name from sources
