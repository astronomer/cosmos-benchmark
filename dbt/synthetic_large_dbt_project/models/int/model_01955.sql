{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01388') }},
        {{ ref('model_01307') }},
        {{ ref('model_00852') }}
)
select id, 'model_01955' as name from sources
