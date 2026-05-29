{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00426') }}
)
select id, 'model_00885' as name from sources
