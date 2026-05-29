{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00400') }},
        {{ ref('model_00558') }},
        {{ ref('model_00302') }}
)
select id, 'model_00958' as name from sources
