{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01564') }},
        {{ ref('model_02248') }}
)
select id, 'model_02659' as name from sources
