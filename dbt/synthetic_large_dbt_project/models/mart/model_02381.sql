{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02103') }}
)
select id, 'model_02381' as name from sources
