{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01082') }}
)
select id, 'model_01831' as name from sources
