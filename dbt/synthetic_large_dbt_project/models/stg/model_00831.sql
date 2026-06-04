{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00554') }},
        {{ ref('model_00423') }}
)
select id, 'model_00831' as name from sources
