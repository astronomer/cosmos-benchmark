{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00514') }},
        {{ ref('model_00714') }}
)
select id, 'model_01117' as name from sources
