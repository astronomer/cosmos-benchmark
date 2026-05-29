{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01718') }}
)
select id, 'model_02366' as name from sources
