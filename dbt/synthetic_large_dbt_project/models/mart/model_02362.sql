{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01754') }},
        {{ ref('model_01849') }},
        {{ ref('model_01781') }}
)
select id, 'model_02362' as name from sources
