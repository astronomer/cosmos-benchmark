{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00049') }},
        {{ ref('model_00296') }}
)
select id, 'model_01366' as name from sources
