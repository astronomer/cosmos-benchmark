{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02111') }},
        {{ ref('model_01542') }}
)
select id, 'model_02535' as name from sources
