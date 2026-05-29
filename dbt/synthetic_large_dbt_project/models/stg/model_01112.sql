{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00079') }}
)
select id, 'model_01112' as name from sources
