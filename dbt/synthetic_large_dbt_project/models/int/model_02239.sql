{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00846') }},
        {{ ref('model_01127') }}
)
select id, 'model_02239' as name from sources
