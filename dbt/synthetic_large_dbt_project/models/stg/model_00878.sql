{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00254') }},
        {{ ref('model_00231') }},
        {{ ref('model_00710') }}
)
select id, 'model_00878' as name from sources
