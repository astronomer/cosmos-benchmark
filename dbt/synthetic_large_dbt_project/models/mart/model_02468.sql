{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01824') }}
)
select id, 'model_02468' as name from sources
