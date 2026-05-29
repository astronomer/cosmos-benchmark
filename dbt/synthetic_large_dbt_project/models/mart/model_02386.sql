{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01622') }}
)
select id, 'model_02386' as name from sources
