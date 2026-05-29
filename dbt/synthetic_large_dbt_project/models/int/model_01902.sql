{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01014') }},
        {{ ref('model_01335') }},
        {{ ref('model_01263') }}
)
select id, 'model_01902' as name from sources
