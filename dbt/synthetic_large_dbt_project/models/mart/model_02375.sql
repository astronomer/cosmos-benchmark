{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01720') }}
)
select id, 'model_02375' as name from sources
