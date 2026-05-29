{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01249') }},
        {{ ref('model_00987') }},
        {{ ref('model_01481') }}
)
select id, 'model_01512' as name from sources
