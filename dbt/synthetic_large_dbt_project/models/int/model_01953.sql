{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01197') }},
        {{ ref('model_01399') }},
        {{ ref('model_01040') }}
)
select id, 'model_01953' as name from sources
