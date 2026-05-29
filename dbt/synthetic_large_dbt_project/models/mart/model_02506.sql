{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01819') }}
)
select id, 'model_02506' as name from sources
