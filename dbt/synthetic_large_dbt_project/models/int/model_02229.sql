{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00843') }}
)
select id, 'model_02229' as name from sources
