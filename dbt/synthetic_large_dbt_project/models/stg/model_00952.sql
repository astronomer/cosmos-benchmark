{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00075') }}
)
select id, 'model_00952' as name from sources
