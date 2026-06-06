{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02225') }},
        {{ ref('model_01987') }},
        {{ ref('model_02048') }}
)
select id, 'model_02484' as name from sources
