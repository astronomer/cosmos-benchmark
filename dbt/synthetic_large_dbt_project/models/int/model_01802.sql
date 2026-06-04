{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01137') }}
)
select id, 'model_01802' as name from sources
