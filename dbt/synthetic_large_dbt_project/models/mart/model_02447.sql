{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01626') }},
        {{ ref('model_02243') }}
)
select id, 'model_02447' as name from sources
