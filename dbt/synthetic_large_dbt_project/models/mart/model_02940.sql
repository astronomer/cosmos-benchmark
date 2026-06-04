{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02247') }},
        {{ ref('model_01542') }}
)
select id, 'model_02940' as name from sources
