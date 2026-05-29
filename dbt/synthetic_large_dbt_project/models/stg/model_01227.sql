{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00413') }},
        {{ ref('model_00130') }},
        {{ ref('model_00301') }}
)
select id, 'model_01227' as name from sources
