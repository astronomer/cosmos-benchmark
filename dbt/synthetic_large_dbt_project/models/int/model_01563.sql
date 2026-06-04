{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01430') }},
        {{ ref('model_01388') }},
        {{ ref('model_01169') }}
)
select id, 'model_01563' as name from sources
