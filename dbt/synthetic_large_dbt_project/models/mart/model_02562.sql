{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01839') }}
)
select id, 'model_02562' as name from sources
