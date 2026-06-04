{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01932') }},
        {{ ref('model_02174') }},
        {{ ref('model_01822') }}
)
select id, 'model_02821' as name from sources
