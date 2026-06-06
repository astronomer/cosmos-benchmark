{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01854') }}
)
select id, 'model_02285' as name from sources
