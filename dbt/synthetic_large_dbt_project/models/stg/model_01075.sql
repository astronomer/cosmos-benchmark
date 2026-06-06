{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00057') }}
)
select id, 'model_01075' as name from sources
