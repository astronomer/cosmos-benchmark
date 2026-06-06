{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02152') }},
        {{ ref('model_02248') }}
)
select id, 'model_02548' as name from sources
