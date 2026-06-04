{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00470') }}
)
select id, 'model_01276' as name from sources
