{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02059') }},
        {{ ref('model_01694') }}
)
select id, 'model_02600' as name from sources
