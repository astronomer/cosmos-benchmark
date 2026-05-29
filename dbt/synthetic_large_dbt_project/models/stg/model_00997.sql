{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00098') }},
        {{ ref('model_00181') }},
        {{ ref('model_00487') }}
)
select id, 'model_00997' as name from sources
