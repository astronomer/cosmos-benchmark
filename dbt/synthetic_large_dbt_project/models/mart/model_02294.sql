{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02055') }}
)
select id, 'model_02294' as name from sources
