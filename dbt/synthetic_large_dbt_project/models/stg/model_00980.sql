{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00369') }},
        {{ ref('model_00397') }},
        {{ ref('model_00480') }}
)
select id, 'model_00980' as name from sources
