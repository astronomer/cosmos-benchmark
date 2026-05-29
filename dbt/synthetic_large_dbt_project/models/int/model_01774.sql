{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01114') }}
)
select id, 'model_01774' as name from sources
