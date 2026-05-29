{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00166') }},
        {{ ref('model_00595') }}
)
select id, 'model_01364' as name from sources
