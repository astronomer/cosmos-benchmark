{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01529') }},
        {{ ref('model_01981') }}
)
select id, 'model_02415' as name from sources
