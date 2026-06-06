{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00383') }}
)
select id, 'model_01196' as name from sources
