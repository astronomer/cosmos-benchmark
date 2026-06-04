{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01871') }},
        {{ ref('model_02230') }},
        {{ ref('model_01798') }}
)
select id, 'model_02340' as name from sources
