{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02229') }}
)
select id, 'model_02521' as name from sources
