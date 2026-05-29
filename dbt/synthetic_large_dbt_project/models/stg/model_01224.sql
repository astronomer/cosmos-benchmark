{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00150') }}
)
select id, 'model_01224' as name from sources
