{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00030') }}
)
select id, 'model_00764' as name from sources
