{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00909') }}
)
select id, 'model_01825' as name from sources
