{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00815') }}
)
select id, 'model_01522' as name from sources
