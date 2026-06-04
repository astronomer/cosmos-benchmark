{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02061') }},
        {{ ref('model_01904') }}
)
select id, 'model_02675' as name from sources
