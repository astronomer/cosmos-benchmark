{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01306') }},
        {{ ref('model_00876') }},
        {{ ref('model_00771') }}
)
select id, 'model_01877' as name from sources
