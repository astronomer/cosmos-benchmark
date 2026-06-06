{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00508') }},
        {{ ref('model_00514') }}
)
select id, 'model_01417' as name from sources
