{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00258') }},
        {{ ref('model_00135') }}
)
select id, 'model_01247' as name from sources
