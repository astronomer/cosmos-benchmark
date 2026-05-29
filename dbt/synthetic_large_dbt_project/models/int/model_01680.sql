{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01211') }},
        {{ ref('model_00918') }}
)
select id, 'model_01680' as name from sources
