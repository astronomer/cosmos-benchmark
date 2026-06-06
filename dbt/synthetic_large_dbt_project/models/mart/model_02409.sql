{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01516') }},
        {{ ref('model_01781') }}
)
select id, 'model_02409' as name from sources
