{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02122') }}
)
select id, 'model_02342' as name from sources
