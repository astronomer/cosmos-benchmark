{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00085') }}
)
select id, 'model_01498' as name from sources
