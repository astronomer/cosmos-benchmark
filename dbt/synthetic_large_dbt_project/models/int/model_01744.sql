{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01004') }},
        {{ ref('model_01127') }},
        {{ ref('model_01212') }}
)
select id, 'model_01744' as name from sources
