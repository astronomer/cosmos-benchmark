{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01383') }},
        {{ ref('model_01417') }},
        {{ ref('model_01202') }}
)
select id, 'model_01539' as name from sources
