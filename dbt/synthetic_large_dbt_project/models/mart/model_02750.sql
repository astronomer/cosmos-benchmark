{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01956') }},
        {{ ref('model_01934') }},
        {{ ref('model_01591') }}
)
select id, 'model_02750' as name from sources
