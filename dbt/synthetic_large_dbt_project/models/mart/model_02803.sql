{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01653') }}
)
select id, 'model_02803' as name from sources
