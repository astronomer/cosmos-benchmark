{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00720') }}
)
select id, 'model_01228' as name from sources
