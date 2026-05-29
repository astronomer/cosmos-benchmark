{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01035') }}
)
select id, 'model_02076' as name from sources
