{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01539') }},
        {{ ref('model_01734') }},
        {{ ref('model_02184') }}
)
select id, 'model_02832' as name from sources
