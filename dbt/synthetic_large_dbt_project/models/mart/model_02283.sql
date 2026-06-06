{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01818') }},
        {{ ref('model_01896') }}
)
select id, 'model_02283' as name from sources
