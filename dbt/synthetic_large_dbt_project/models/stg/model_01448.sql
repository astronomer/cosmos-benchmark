{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00164') }}
)
select id, 'model_01448' as name from sources
