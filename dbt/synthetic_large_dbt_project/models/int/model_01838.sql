{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01394') }},
        {{ ref('model_01399') }},
        {{ ref('model_00902') }}
)
select id, 'model_01838' as name from sources
