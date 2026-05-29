{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01088') }},
        {{ ref('model_00852') }}
)
select id, 'model_01742' as name from sources
