{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00262') }}
)
select id, 'model_01429' as name from sources
