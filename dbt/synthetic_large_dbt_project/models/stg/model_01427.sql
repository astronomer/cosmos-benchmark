{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00701') }}
)
select id, 'model_01427' as name from sources
