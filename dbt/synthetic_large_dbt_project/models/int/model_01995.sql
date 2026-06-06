{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01181') }},
        {{ ref('model_00872') }}
)
select id, 'model_01995' as name from sources
