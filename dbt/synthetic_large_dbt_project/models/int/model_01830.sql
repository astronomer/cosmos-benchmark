{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01181') }}
)
select id, 'model_01830' as name from sources
