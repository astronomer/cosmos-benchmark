{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00356') }},
        {{ ref('model_00195') }}
)
select id, 'model_01124' as name from sources
