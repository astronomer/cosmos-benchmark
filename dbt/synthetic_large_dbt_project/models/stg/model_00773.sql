{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00377') }}
)
select id, 'model_00773' as name from sources
