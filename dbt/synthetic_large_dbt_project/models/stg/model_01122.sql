{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00574') }}
)
select id, 'model_01122' as name from sources
