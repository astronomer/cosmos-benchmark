{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01877') }},
        {{ ref('model_01703') }},
        {{ ref('model_01542') }}
)
select id, 'model_02851' as name from sources
