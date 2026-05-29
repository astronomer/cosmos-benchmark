{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02054') }},
        {{ ref('model_01572') }},
        {{ ref('model_01649') }}
)
select id, 'model_02708' as name from sources
