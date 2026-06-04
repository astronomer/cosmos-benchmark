{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02200') }}
)
select id, 'model_02913' as name from sources
