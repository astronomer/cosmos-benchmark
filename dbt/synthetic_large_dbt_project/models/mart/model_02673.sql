{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02057') }},
        {{ ref('model_01542') }},
        {{ ref('model_02032') }}
)
select id, 'model_02673' as name from sources
