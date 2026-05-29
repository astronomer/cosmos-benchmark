{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00833') }},
        {{ ref('model_00844') }}
)
select id, 'model_01550' as name from sources
