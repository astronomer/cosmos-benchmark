{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01136') }},
        {{ ref('model_00921') }}
)
select id, 'model_01714' as name from sources
