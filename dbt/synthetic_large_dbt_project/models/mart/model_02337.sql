{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01969') }}
)
select id, 'model_02337' as name from sources
