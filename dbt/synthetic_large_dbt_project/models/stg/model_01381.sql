{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00616') }}
)
select id, 'model_01381' as name from sources
