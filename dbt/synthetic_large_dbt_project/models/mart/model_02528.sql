{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01904') }},
        {{ ref('model_01542') }},
        {{ ref('model_02212') }}
)
select id, 'model_02528' as name from sources
