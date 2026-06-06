{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00678') }}
)
select id, 'model_00976' as name from sources
